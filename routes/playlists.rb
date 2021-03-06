post('/playlists') do
  name = params.fetch('playlist_name')
  description = params.fetch('playlist_description')
  due_date = params.fetch('due_date')
  is_private = params.has_key?('private')
  playlist = Playlist.create({:name => name, :description => description, :due_date => due_date, :is_private => is_private})
  new_tags = params.fetch('new-tags')
  Tag.make_all(new_tags).each do |tag|
    playlist.tags.push(tag)
  end
  env['warden'].user.playlists.push(playlist) if env['warden'].user
  redirect "/playlists/#{playlist.id}"
end

get('/playlists') do
  @playlists = Playlist.all

  @playlists = @user.playlists if env['warden'].user
  erb(:playlist_list)
end

get('/playlists/:id') do
  @playlist = Playlist.find(params.fetch('id').to_i)
  @lessons = Lesson.all
  @lessons = @user.lessons if env['warden'].user
  erb(:playlist_detail)
end

patch('/playlists/:id') do
  playlist = Playlist.find(params.fetch('id').to_i)
  name = params.fetch('playlist_name')
  description = params.fetch('new_playlist_description')
  due_date = params.fetch('new_due_date')
  playlist.update({:name => name, :description => description, :due_date => due_date})
  redirect('/playlists')
end

patch("/playlists/:id/lessons/add") do
  lesson = Lesson.find(params.fetch("lesson_id").to_i)
  playlist = Playlist.find(params.fetch("id").to_i)
  playlist.lessons.push(lesson)
  redirect "/playlists"
end

delete('/playlists/:id') do
  Playlist.find(params.fetch('id').to_i).destroy
  redirect('/playlists')
end

post('/playlists/:id/tags') do
  playlist = Playlist.find(params.fetch('id').to_i)
  new_tags = params.fetch('new-tags')
  Tag.make_all(new_tags).each do |tag|
    unless playlist.tags.find_by_name(tag.name)
      playlist.tags.push(tag)
    end
  end
  redirect "/playlists/#{params.fetch('id').to_i}"
end

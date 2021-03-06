class Lesson < ActiveRecord::Base
  has_and_belongs_to_many(:playlists)
  has_and_belongs_to_many(:tags)
  has_and_belongs_to_many(:users)

  after_initialize(:init)

  def init
    self.is_private = false if self.is_private.nil?
    self.complete = false if self.complete.nil?
  end
end

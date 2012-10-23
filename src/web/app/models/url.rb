class Url < ActiveRecord::Base
  attr_accessible :description, :page_title, :url
  belongs_to :user

  # virtual attributes
  attr_accessible :poster

  validates :url, presence: true
  validates :poster, presence: true

  # poster is a virtual attribute
  # behind scene, it operates on user_id
  # Usage:
  # => u = User.find(6)
  # => url = Url.new
  # => url.poster = u
  # => url.poster
  def poster=(poster)
    self.user_id = poster.id
  end

  def poster
    User.find(self.user_id)
  end
end

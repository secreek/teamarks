class Url < ActiveRecord::Base
  attr_accessible :text, :page_title, :url

  validates :url, presence: true
  validates :user_id, presence: true
end

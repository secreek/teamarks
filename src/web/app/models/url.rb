class Url < ActiveRecord::Base
  attr_accessible :description, :page_title, :url
  belongs_to :user
end

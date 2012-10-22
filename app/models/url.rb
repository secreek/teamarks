class Url < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :url,	:page_title,	presence:true
end

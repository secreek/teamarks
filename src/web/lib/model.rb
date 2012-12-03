# Teamarks Database Schema
# 

class Teammember

  include DataMapper::Resource
  property :id,			Serial
  property :is_admin,	String
  property :created_at,	DateTime

  belongs_to :team
  belongs_to :user

end


class User
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :username,   String,	:required => true
  property :email,  		String, :required => true, :unique => true, :format => :email_address  
  property :token,	   	String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name
  has n, :urls
  has n, :teammembers
  has n, :teams, :through => :teammembers
end

class Url
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :url,     	String,	:required => true, :format => :url
  property :title,		String, :length => 255
  property :text,		Text 
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :url
  belongs_to :user
end

class Team
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :name,       String 
  property :maillist,   String, :format => :email_address
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name
  has n, :teammembers
  has n, :users, :through => :teammembers
end

#DataMapper.finalize
#DataMapper.auto_upgrade!

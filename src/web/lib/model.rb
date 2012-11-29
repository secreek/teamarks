# Teamarks Database Schema
# 

class Teammember

  include DataMapper::Resource
  property :id,			Serial
  property :created_at,	DateTime

  belongs_to :team
  belongs_to :user

end

class User
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :username,   String
  property :email,		String, :required => true, :unique => true, :format => :email_address  
  property :token,		String
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
  property :url,     	String
  property :title,		String
  property :text,		Text 
  property :created_at, DateTime
  property :updated_at, DateTime
  property :user_id,	String

  validates_presence_of :url
  belongs_to :user
end

class Team
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :name,       String
  property :admin_id,	String  
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name
  has n, :teammembers
  has n, :users, :through => :teammembers
end

DataMapper.finalize
DataMapper.auto_upgrade!
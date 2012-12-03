# Teamarks Database Schema
#
class User
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :claimed_id, String, :required => true, :unique => true
  property :nickname,   String, :required => true, :unique => true
  property :email,      String, :required => true, :unique => true, :format => :email_address
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :claimed_id
  has n, :team_members
  has n, :teams, :through => :team_members
  has n, :marks
end

class Team
  include DataMapper::Resource

  property :id,          Serial, :key => true
  property :name,        String, :required => true
  property :description, Text
  property :mailinglist, String, :format => :email_address
  property :created_at,  DateTime
  property :updated_at,  DateTime

  validates_presence_of :name
  has n, :team_members
  has n, :users, :through => :team_members
  has n, :marks
end

class TeamMember
  include DataMapper::Resource

  property :id,			    Serial
  property :role,	      Integer
  property :status,     Integer
  property :created_at,	DateTime
  property :updated_at, DateTime

  belongs_to :team
  belongs_to :user
end

class Mark
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :url,     	  String,	:required => true, :format => :url
  property :title,		  String, :length => 255
  property :text,		    Text
  property :channel,    Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :url
  belongs_to :user
  belongs_to :team
end

class InvitationCode
  include DataMapper::Resource

  property :id,         Serial,  :key => true
  property :code,       String,  :required => true
  property :valid,      Boolean, :required => true
  property :created_at, DateTime
end

DataMapper.finalize
DataMapper.auto_migrate!

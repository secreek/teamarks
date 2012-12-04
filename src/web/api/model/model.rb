# Teamarks Database Schema
#
class User
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :claimed_id, String, :required => true, :unique => true
  property :nickname,   String, :required => true, :unique => true
  property :email,      String, :required => true, :unique => true, :format => :email_address
  property :created_at, DateTime, :default => Time.now
  property :updated_at, DateTime, :default => Time.now

  validates_presence_of :claimed_id
  has n, :team_members
  has n, :teams, :through => :team_members
  has n, :marks

  def to_s
    "#{nickname} (identified by #{claimed_id})"
  end
end

class Team
  include DataMapper::Resource

  property :id,          Serial, :key => true
  property :name,        String, :required => true
  property :description, Text
  property :mailinglist, String, :format => :email_address
  property :created_at,  DateTime, :default => Time.now
  property :updated_at,  DateTime, :default => Time.now

  validates_presence_of :name
  has n, :team_members
  has n, :users, :through => :team_members
  has n, :marks

  def to_s
    "#{name} (#{description})"
  end
end

class TeamMember
  include DataMapper::Resource

  property :id,			    Serial,   :key => true
  property :role,	      Integer,  :required => true
  property :status,     Integer,  :required => true
  property :created_at,	DateTime, :default => Time.now
  property :updated_at, DateTime, :default => Time.now

  belongs_to :team
  belongs_to :user

  def to_s
    "User '#{user}' @ Team '#{team}'"
  end
end

class Mark
  include DataMapper::Resource

  property :id,         Serial, :key => true
  property :url,     	  String,	:required => true, :format => :url
  property :title,		  String, :length => 255, :required => true
  property :text,		    Text
  property :channel,    Integer, :required => true
  property :created_at, DateTime, :default => Time.now
  property :updated_at, DateTime, :default => Time.now

  validates_presence_of :url
  belongs_to :user
  belongs_to :team

  def to_s
    "#{title}(#{url}) shared by User '#{user}' to Team '#{team}'"
  end
end

class InvitationCode
  include DataMapper::Resource

  property :id,          Serial, :key => true
  property :code,        String, :required => true
  property :still_valid, Boolean, :required => true
  property :created_at,  DateTime, :default => Time.now

  def taken
    self.update(:still_valid => false)
  end

  def to_s
    status = still_valid ? 'valid' : 'invalid'
    "#{code}[#{status}] (created_at #{created_at})"
  end
end

DataMapper.finalize
# Don't need auto_migrate cause rake does that for us
#DataMapper.auto_migrate!

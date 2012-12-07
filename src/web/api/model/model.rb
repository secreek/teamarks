require 'data_mapper'

#Teamarks Database Schema
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

  def to_json_obj
    {
      'id' => id,
      'claimed_id' => claimed_id,
      'nickname' => nickname,
      'email' => email,
      'created_at' => created_at,
      'updated_at' => updated_at
    }
  end

  def self.normalize_params params
    possible_param_keys = ["claimed_id", "nickname", "email", "created_at", "updated_at"]
    params.delete_if {|key, value| !possible_param_keys.include?(key) }
  end

  def self.is_unique_attribute? name
    return ["claimed_id", "nickname", "email"].include? name
  end
end

class Team
  include DataMapper::Resource

  property :id,          Serial, :key => true
  property :name,        String, :required => true, unique => true
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

  def to_json_obj
    {
      'id' => id,
      'name' => name,
      'description' => description,
      'created_at' => created_at,
      'updated_at' => updated_at
    }
  end

  def self.normalize_params params
    possible_param_keys = ["name", "description", "created_at", "updated_at"]
    params.delete_if {|key, value| !possible_param_keys.include?(key) }
  end

  def self.is_unique_attribute? name
    return ["name"].include? name
  end
end

class TeamMember
  include DataMapper::Resource

  property :id,			    Serial,   :key => true
  property :role,	      Integer,  :default => 0
  property :status,     Integer,  :default => 0
  property :created_at,	DateTime, :default => Time.now
  property :updated_at, DateTime, :default => Time.now

  belongs_to :team
  belongs_to :user

  def to_s
    "User '#{user}' @ Team '#{team}'"
  end

  def to_json_obj
    {
      'id' => id,
      'team' => team.to_json_obj,
      'user' => user.to_json_obj,
      'role' => role,
      'status' => status,
      'created_at' => created_at,
      'updated_at' => updated_at
    }
  end

  def self.normalize_params params
    possible_param_keys = ["id", "role", "status", "team", "user", "created_at", "updated_at"]
    params.delete_if {|key, value| !possible_param_keys.include?(key) }
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
    "#{title}(#{url}) shared by User '#{user}' to Team '#{team}' from Channel '#{channel}"
  end

  def to_json_obj
    {
      'id' => id,
      'url' => url,
      'title' => title,
      'text' => text,
      'channel' => channel,
      'team' => team.to_json_obj,
      'user' => user.to_json_obj,
      'created_at' => created_at,
      'updated_at' => updated_at
    }
  end

  def self.normalize_params params
    possible_param_keys = ["id", "url", "title", "text", "channel", "team", "user", "created_at", "updated_at"]
    params.delete_if {|key, value| !possible_param_keys.include?(key) }
  end
end

class InvitationCode
  include DataMapper::Resource

  property :id,          Serial, :key => true
  property :code,        String, :required => true
  property :still_valid, Boolean, :default => true
  property :created_at,  DateTime, :default => Time.now

  def taken
    self.update(:still_valid => false)
  end

  def to_s
    status = still_valid ? 'valid' : 'invalid'
    "#{code}[#{status}] (created_at #{created_at})"
  end

  def to_json_obj
    {
      'id' => id,
      'code' => code,
      'still_valid' => still_valid,
      'created_at' => created_at
    }
  end

  def self.normalize_params params
    possible_param_keys = ["id", "code", "still_valid", "created_at", "updated_at"]
    params.delete_if {|key, value| !possible_param_keys.include?(key) }
  end
end

DataMapper.finalize
# Remove the auto_migrate and auto_upgrade method from the model file
# you can run the method with rake （check the Rakefile）
#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!

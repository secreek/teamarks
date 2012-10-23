require 'digest/md5'

class User < ActiveRecord::Base
  attr_accessible :email, :password, :username

  validates :email, presence: true
  validates :password, presence: true
  validates :username, presence: true

  before_save :fill_in_apikey

  private
    def fill_in_apikey
      key = self.username + "@" + DateTime.now.to_s
      self.apikey = Digest::MD5.hexdigest(key)
    end
end

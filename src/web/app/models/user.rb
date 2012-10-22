class User < ActiveRecord::Base
  attr_accessible :apikey, :email, :password, :username
end

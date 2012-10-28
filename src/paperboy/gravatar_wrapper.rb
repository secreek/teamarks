require 'digest/md5'

class GravatarWrapper
  def calculate(email)
    email_hash = Digest::MD5.hexdigest email.strip.downcase
    "http://www.gravatar.com/avatar/#{email_hash}?s=64"
  end
end

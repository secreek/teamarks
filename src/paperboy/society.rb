# General Abstract Charactors in Paperboy's World
# Types of notification client may be:
#   - Email
#   - SMS
#   - Web Service Post
#   - Desktop Notification
#   - Mac Remember
#   - Mobile App

class News
end

class Subscribers
end

class Templet
  attr_accessor :sender_name, :sender_uri, :recipient_uri, :recipient_name, :subject

  def initialize
    reset
  end

  def reset
    @sender_name = ''
    @sender_uri = ''
    @recipient_uri = ''
    @recipient_name = ''
    @subject = ''
  end
end

class Composer
  attr_accessor :templet, :news
  def initialize(templet, source)
    @templet = templet
    @news = source
  end

  def compose
    yield @templet, @news
    @templet
  end
end

class Paperboy
  def deliver(paper)
    raise "Not implemented."
  end
end


# Teamark Support

require 'json'
require_relative 'settings'

module TeaMarks_API
  include Settings

  def get_bookmarks
    endpoint = @options['endpoint_bookmarks']
    last = options['last']
    jr = request(endpoint + '?after=' + last)
    options['last'] = jr['last']
    save
    jr['result']
  end

  def get_subscribers
    endpoint = options['endpoint_subscribers']
    request(endpoint)
  end

  def request(url)
    begin
      response = Net::HTTP.get_response(URI.parse(url))
      JSON.parse(response.body)
    rescue
      # Notify the admin
      raise "Mission abandoned."
    end
  end
end

class TeamBookmarks < News
  include TeaMarks_API

  attr_accessor :doc

  def initialize
    super
    @doc = get_bookmarks
  end

  def to_s
    s = ''
    @doc.each do |user_share|
      s << yield(user_share['userid'])
      s << usershare.links.each {|link| s << link['title'] << link['url'] << link['description'] << ''}
    end
    s
  end
end

class TeamMembers < Subscribers
  include TeaMarks_API

  attr_accessor :doc

  def initialize
    super
    @doc = get_subscribers
  end
end

class TeamarksTemplet < EmailTemplet
  def reset
    super
    @sender_name = "Teamarks"
    @sender_uri = "noreply@teamarks.com"
    @subject = 'Bookmarks Shared by Your Teammates'
  end
end

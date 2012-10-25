# Teamark Support

require 'json'
require 'net/http'
require_relative 'settings'

module TeaMarksAPI
  include Settings

  def initialize
    super
  end

  def bookmarks
    endpoint = options["endpoint_bookmarks"]
    last = options["last"].to_i
    jr = request("%s?after=%d" % [endpoint, last])
    options['last'] = jr['last']
    save
    jr['result']
  end

  def subscribers
    endpoint = options['endpoint_subscribers']
    request(endpoint)
  end

  def request(url)
    begin
      response = Net::HTTP.get_response(URI.parse(url))
      if response.body.length > 0
        JSON.parse(response.body)
      end
    rescue
      # Notify the admin
      raise "Mission abandoned."
    end
  end
end

class TeamBookmarks < News
  include TeaMarksAPI

  attr_accessor :doc, :users

  def initialize
    super
    @doc = bookmarks
    @users = subscribers
  end

  def member_name(id)
    list = @users.select do |user|
      user['id'] == id
    end

    list.length == 0 ? 'Unknown User' : list[0]['username']
  end

  def to_s
    s = ''
    @doc.each do |user_share|
      uid = member_name user_share['user_id']
      user_share['links'].each do |link|
        s << "%s/%s/%s\r\n" %
              [link['page_title'], link['url'], link['description']]
      end

      if s.length > 0
        s = "%s\r\n%s" % [uid, s]
      end
    end
    s.strip
  end
end

class TeamMembers < Subscribers
  include TeaMarksAPI

  attr_accessor :doc

  def initialize
    super
    @doc = subscribers
  end
end

class TeamarksTemplet < EmailTemplet
  attr_accessor :sender_name, :sender_uri, :subject
  def initialize
    super
    reset
  end

  def reset
    super
    @sender_name = "Teamarks"
    @sender_uri = "noreply@teamarks.com"
    @subject = 'Bookmarks Shared by Your Teammates'
  end
end

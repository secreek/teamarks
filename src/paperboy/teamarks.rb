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
      else
        nil
      end
    rescue
      # Notify the admin
      raise "Mission abandoned."
    end
  end
end

class TeamBookmarks < News
  include TeaMarksAPI

  attr_accessor :doc

  def initialize
    super
    @doc = bookmarks
  end

  def to_s
    s = ''
    @doc.each do |user_share|
      uid = user_share['user_id'].to_s
      s << uid << "\r\n"
      user_share['links'].each do |link|
        s << "Page Title: %s (%s) \r\n" % [link['page_title'], link['url']]
        s << "Description: %s\r\n" % link['description']
      end
    end
    s
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

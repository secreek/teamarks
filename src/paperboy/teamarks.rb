# Teamark Support

require 'json'
require 'net/http'
require_relative 'settings'
require_relative 'gravatar_wrapper.rb'

module TeaMarksAPI
  def initialize
    Settings.instance.load
  end

  def bookmarks
    endpoint = Settings.instance.options["endpoint_bookmarks"]
    last = Settings.instance.options["last"].to_i
    jr = request("%s?after=%d" % [endpoint, last])
    Settings.instance.options['last'] = jr['last']
    Settings.instance.save
    jr['result']
  end

  def subscribers
    endpoint = Settings.instance.options['endpoint_subscribers']
    request(endpoint)
  end

  private
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

  attr_accessor :news

  def initialize
    super
    @news = bookmarks
  end

  def has_news?
    (@news.inject(0) { |sum, content| sum + content['links'].length }) > 0
  end
end

class TeamMembers < Subscribers
  include TeaMarksAPI

  attr_accessor :members

  def initialize
    super
    @members = subscribers
  end

  # team member helper methods
  # TODO replace this with meta programming
  def member_name(id)
    list = @members.select do |user|
      user['id'] == id
    end

    list.length == 0 ? 'Unknown User' : list[0]['username']
  end

  def member_email(id)
    list = @members.select do |user|
      user['id'] == id
    end

    list.length == 0 ? '' : list[0]['email']
  end
end

class TeaMarksEmailTemplet < EmailTemplet
  def initialize
    super
    reset
  end

  def reset
    super
    @sender_name = "Teamarks"
    @sender_uri = "noreply@teamarks.com"
    @subject = "Bookmarks Shared by Your Teammates"
    @marker = "TEAMARKS_MAIL_SEPERATOR"
  end
end

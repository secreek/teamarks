# Teamark Support

require 'json'
require 'net/http'
require_relative 'settings'
require_relative 'gravatar_wrapper.rb'

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

  def member_email(id)
    list = @users.select do |user|
      user['id'] == id
    end

    list.length == 0 ? '' : list[0]['email']
  end

  def share_item_template
    msg = "<li class=\"link\">
      <a href=\"%s\" title=\"%s\">
        <div class=\"title\">
          %s
        </div>
        <div class=\"site\">
          <img class=\"favicon\" src=\"http://g.etfv.co/%s\"/>
          <span class=\"host\">%s</span>
        </div>
        <p class=\"text\">
          %s
        </p>
      </a>
    </li>"
  end

  def to_s
    g = GravatarWrapper.new
    s = ''
    @doc.each do |user_share|
      uid = member_name user_share['user_id']
      uemail = member_email user_share['user_id']
      image_url = g.calculate(uemail)
      pre = "<li class=\"user_share\">
      <img class=\"avatar\" src=\"%s\" title=\"%s\"/>
      <ul class=\"links\">" % [image_url, uid]
      post = "</ul></li>"
      content = ''
      user_share['links'].each do |link|
        schema, path = link['url'].split(/\/\//)
        path = path.split(/\//)[0]
        host = "#{schema}//#{path}"
        content << share_item_template %
              [link['url'], link['url'], link['page_title'],
               host, host, link['text']]
      end

      if content.length > 0
        s << "%s %s %s" % [pre, content, post]
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

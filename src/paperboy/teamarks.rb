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
    msg = "<li class=\"link\" style=\"list-style-type: none; margin: 0;
      padding: 0; list-style-position: inside; margin: 0 0 20px 0;\">
      <a style=\"display: block; text-decoration: none; width: 100%%;
        color: rgb(51,51,51); padding: 5px\"
        href=\"%s\" title=\"%s\">
        <div style=\"font-size: large; padding: 5px; text-shadow: 0px 1px 1px white;\">
          %s
        </div>
        <div style=\"background-color: white; line-height: 16px; padding: 5px;
          background: -webkit-linear-gradient(left, white 0%%, #ddd 100%%)\">
          <img style=\"display: inline-block; vertical-align: middle\"
            src=\"http://g.etfv.co/%s\"/>
          <span style=\"display: inline-block; color: #666;
            vertical-align: middle;\">%s</span>
        </div>
        <p style=\"color: #666; margin: 3px 0; font-size: small; padding: 5px;
          font-family: \"Palatino\", serif\">
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
      pre = "<li style=\"list-style-type: none; margin: 0; padding: 0;
        list-style-position: inside; background-color: #ddd; border-radius: 5px;
        margin: 0 0 30px 0\">
      <img style=\"width: 64px; height: 64px; display: inline-block;
        box-shadow: 0px 3px 8px gray; vertical-align: top\"
        src=\"%s\" title=\"%s\"/>
      <ul style=\"display: inline-block; width: 300px; margin: 0; padding: 0; margin-left: 30px\">" % [image_url, uid]
      post = "</ul></li>"
      content = ''
      user_share['links'].each do |link|
        schema, path = link['url'].split(/\/\//)
        host = path.split(/\//)[0]
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

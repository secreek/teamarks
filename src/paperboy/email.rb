# Sending Email as one of notifications

require 'rubygems'
require 'net/smtp'
require 'erb'
require_relative 'settings'

class EmailTemplet < Templet
  # Email specfic data
  attr_accessor :mail_parts, :marker, :mail_content

  def initialize
    super
    reset
  end

  def reset
    super
    @mail_parts = []
    @mail_content = ""
  end

  def add_part(erb_file, data)
    erb = ERB.new(open(erb_file).read.gsub(/\n/, "\r\n"))
    bookmarks = data.news
    @mail_parts << erb.result(binding)
  end
end

class EmailComposer < Composer
  def initialize(templet, news)
    super(templet, news)

    @part_template_files = ['templates/mail_part.text.erb',
      'templates/mail_part.html.erb']
  end

  def compose
    @templet.reset
    @part_template_files.each do |template_file|
      @templet.add_part(template_file, news)
    end
    yield @templet

    mail = ERB.new(open('templates/email.main.erb').read.gsub(/\n/, "\r\n"))
    @templet.mail_content = mail.result(binding)
    @templet
  end
end

class Mailer
  def initialize
    # These settings are never gonna change once the instance is created
    @smtp_addr = Settings.instance.options['smtp_addr']
    @smtp_port = Settings.instance.options['smtp_port']
  end

  def send(msg, from, to)
    Net::SMTP.start('localhost') do |smtp|
      # smtp.set_debug_output $stderr
      smtp.send_message(msg, from, to)
    end
  end
end

class Spammer < Paperboy
  def deliver(paper)
    mailer = Mailer.new
    mailer.send(paper.mail_content,
      "#{paper.sender_name} <#{paper.sender_uri}>",
      "#{paper.recipient_name} <#{paper.recipient_uri}>")
  end
end

# Sending Email as one of notifications

require 'rubygems'
require 'net/smtp'
require_relative 'settings'

class EmailTemplet < Templet
  def to_s
    template_content = open('email.html').read
    puts template_content
    puts template_content.class
    template_content % [@subject, @message_body]
  end
end

class EmailComposer < Composer
  def initialize(templet, news)
    super(templet, news)
  end
end

class Mailer
  def initialize
    # These settings are never gonna change once the instance is created
    @smtp_addr = Settings.instance.options['smtp_addr']
    @smtp_port = Settings.instance.options['smtp_port']
  end

  def send(msg, from, to)
    # send email only when someone actually shared something
    if msg.message_body.length > 0
      Net::SMTP.start('localhost') do |smtp|
        # smtp.set_debug_output $stderr
        smtp.send_message(msg.to_s, from.to_s, to.to_s)
      end
    end # else, give up send email
  end
end

class Spammer < Paperboy
  def deliver(paper)
    mailer = Mailer.new
    mailer.send(paper,
      "#{paper.sender_name} <#{paper.sender_uri}>",
      "#{paper.recipient_name} <#{paper.recipient_uri}>")
  end
end



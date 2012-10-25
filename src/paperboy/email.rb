# Sending Email as one of notifications

require 'rubygems'
require 'net/smtp'
require_relative 'settings'

class EmailTemplet < Templet
  def to_s
    "MIME-Version:1.0\r\n
Content-type:text/html\r\n
Subject:#{@subject}\r\n\r\n
Dear #{@recipient_name},\r\n\r\n
Today's new arrivals in Teamarks:\r\n\r\n
#{@message_body}"

    open('email.html').read
  end
end

class EmailComposer < Composer
  def initialize(templet, news)
    super(templet, news)
  end
end

class Mailer
  include Settings
  def initialize
    @smtp_addr = options['smtp_addr']
    @smtp_port = options['smtp_port']

    super # make sure the module's initialize got called
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
    mailer.send(paper, "#{paper.sender_name} <#{paper.sender_uri}>", "#{paper.recipient_name} <#{paper.recipient_uri}>")
  end
end



# Sending Email as one of notifications

require 'rubygems'
require 'net/smtp'
require 'settings'

class EmailTemplet < Templet
  def to_s
    @subject + "\r\n\r\n" + "Dear #{@recipient_name},\r\n\r\n" + @message_body
  end
end

class EmailComposer < Composer
end

class Mailer
  include Settings
  def initialize
    @smtp_addr = options['smtp_addr']
    @smtp_port = options['smtp_port']
  end
  
  def send(msg, from, to)
    if @smtp_addr and @smtp_port
      smtp = Net::SMTP.new(addr, port)
    else
      # Defaults to localhost and port 25
      smtp = Net::SMTP.new('localhost')

    smtp.set_debug_output $stderr
    smtp.start do {|smtp| smtp.send_message(msg, from, to)
  end
end

class Spammer < Paperboy
  def deliver(paper)
    mailer = new Mailer()
    mailer.send(paper, "#{paper.sender_name} <#{paper.sender_urn}>", "#{paper.recipient_name} <#{paper.recipient_urn}>")
  end
end



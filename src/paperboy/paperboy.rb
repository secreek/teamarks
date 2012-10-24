# Paperboy for Teamarks
# = Main Entrance File =
#
# Known Issues: 
#   * No team support
#

require 'society'
require 'email'
require 'teamarks'

composer = EmailComposer(EmailTemplet.new, TeamBookmarks.new)
subscribers = TeamMembers.new
boy = Spammer.new(subscribers, composer)

subcribers.docs.each do |subcriber|
  paper = composer.compose do |templet, news|
    templet.recipient_name = subcriber['nickname']
    templet.recipient_urn = subcriber['email']
    templet.message_body = news.to_s {|userid| subcriber.select {|user| user['user_id'] == userid}}
  end

  boy.deliver paper
end

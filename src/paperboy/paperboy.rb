# Paperboy for Teamarks
# = Main Entrance File =
#
# Known Issues:
#   * No team support
#

require_relative 'society'
require_relative 'email'
require_relative 'teamarks'

composer = EmailComposer.new(TeamarksTemplet.new, TeamBookmarks.new)
subscribers = TeamMembers.new
boy = Spammer.new

subscribers.doc.each do |subcriber|
  paper = composer.compose do |templet, news|
    templet.recipient_name = subcriber['username']
    templet.recipient_uri = subcriber['email']
    templet.message_body = news.to_s {|userid| subcriber.select {|user| user['user_id'] == userid}}
  end

  boy.deliver paper
end

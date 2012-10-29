# Paperboy for Teamarks
# = Main Entrance File =
#
# Known Issues:
#   * No team support
#

require_relative 'society'
require_relative 'email'
require_relative 'teamarks'

news = TeamBookmarks.new
composer = EmailComposer.new(EmailTemplet.new, news)
subscribers = TeamMembers.new
boy = Spammer.new

if news.has_news?
  subscribers.members.each do |subcriber|
    paper = composer.compose do |templet|
      templet.recipient_name = subcriber['username']
      templet.recipient_uri = subcriber['email']
    end

    boy.deliver paper
  end
end

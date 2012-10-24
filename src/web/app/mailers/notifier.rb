class Notifier < ActionMailer::Base
  default from: "noreply@teamarks.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.daily.subject
  #
  def daily(email)
    @greeting = "Here is your team daily bookmark digest"

    mail(:to=>email,:subject =>"Daily Team Digest") 
  end
end

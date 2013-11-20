class NewNotificationMailer < ActionMailer::Base
  default :from => 'notifications@share.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_notification_mailer.new_friendship_request.subject
  #
  def new_appeal(user, receiver)
    @you = receiver.name
    @friend = user.name
    mail to: receiver.email, subject: "Someone want be your friend!"
  end

   def appeal_accepted(user, receiver)
    @you = user.name
    @friend = receiver.name
    mail to: user.email, subject: "You have a new friend"
  end
end

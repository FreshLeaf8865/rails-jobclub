class UserWelcomeActivity
  KEY = "user.welcome"

  def self.get_recipients_for(activity)
    recepients = [activity.owner]
  end

  def self.send_notification(notification)
    NotificationMailer.delay.user_welcome(notification)
  end
end
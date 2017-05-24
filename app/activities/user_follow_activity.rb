class UserFollowActivity
  KEY = "user.follow"

  def self.get_recipients_for(activity)
    recepients = [activity.trackable]
  end

  def self.send_notification(notification)
    NotificationMailer.delay.user_followed(notification)
    self.send_push(notification)
  end

  def self.send_push(notification)
    return unless notification.present?

    follower = notification.activity.owner
    link = Rails.application.routes.url_helpers.user_url(follower, host: Rails.application.secrets.domain_name)

    OnesignalService.send(  notification, 
                            "#{follower.display_name} followed you on HireClub",
                            link,
                            nil)
  end
end
class ReviewRequestCreateActivity
  KEY = "review_request.create"

  def self.get_recipients_for(activity)
    recepients = [activity.owner] + User.reviewers
  end

  def self.send_notification(notification)
    NotificationMailer.delay.review_request(notification)
  end
end
class JobPublishActivity
  KEY = "job.publish"

  def self.get_recipients_for(activity)
    # Company followers + User Followers + Admin - job poster
    recepients = activity.trackable.company.followers + activity.trackable.user.followers + User.admin - [activity.trackable.user]
  end

  def self.send_notification(notification)
    NotificationMailer.delay.job_created(notification)
  end

end

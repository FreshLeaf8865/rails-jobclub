class ProjectCreateActivity
  KEY = "project.create"

  def self.get_recipients_for(activity)
    # User followers except person who createed project
    recepients = activity.trackable.user.followers + User.admin - [activity.trackable.user]
  end

  def self.send_notification(notification)
    NotificationMailer.delay.project_created(notification)
  end

end
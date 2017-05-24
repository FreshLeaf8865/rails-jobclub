class StoryPublishActivity
  KEY = "story.publish"

  def self.get_recipients_for(activity)
    # Story User followers
    recepients = activity.trackable.user.followers + User.admin - [activity.trackable.user]
  end

  def self.send_notification(notification)
    NotificationMailer.delay.story_published(notification)
  end

end
class CommentCreateActivity
  KEY = "comment.create"

  def self.get_recipients_for(activity)
    comment = activity.trackable
    commentable = comment.commentable
    # send out notifications to commentable user
    recepients = commentable.commenters - [comment.user]
    recepients << commentable.user if commentable.user != comment.user
    recepients
  end

  def self.send_notification(notification)
    NotificationMailer.delay.comment_created(notification)
  end

end
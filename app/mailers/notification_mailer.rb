class NotificationMailer < ApplicationMailer
  default from: "HireClub <no-reply@hireclub.co>"

  def user_welcome(notification)
    @notification = Notification.find notification
    @user = @notification.user

    mail(to: @user.email, subject: 'Welcome to HireClub! 🍾')
  end

  def review_request(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @activity = @notification.activity
    @review_request = @activity.trackable
    @owner = @review_request.user

    if @owner == @user
      subject = "Your Profile Review"
      template_name = "review_request"
    else
      subject = "#{@owner.display_name} is asking for a profile review"
      template_name = "review_request_reviewer"
    end
    mail(to: @user.email, subject: subject, template_name: template_name)
  end

  def comment_created(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @comment = @notification.activity.trackable
    @commentable = @comment.commentable
    mail(to: @user.email, subject: 'New Comment')
  end

  def comment_mentioned(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @comment = @notification.activity.trackable.mentionable
    @commentable = @comment.commentable
    mail(to: @user.email, subject: 'New Mention')
  end

  def job_created(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @job = @notification.activity.trackable
    @company = @job.company
    mail(to: @user.email, subject: "#{@job.company.name} posted job #{@job.name}")
  end

  def story_published(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @story = @notification.activity.trackable

    mail(to: @user.email, subject: "#{@story.user.display_name} published #{@story.name}")
  end

  def project_created(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @project = @notification.activity.trackable

    mail(to: @user.email, subject: "#{@project.user.display_name} added project #{@project.name}")
  end

  def user_followed(notification)
    @notification = Notification.find notification
    @user = @notification.user
    @follower = notification.activity.owner

    @subject = "#{@follower.display_name} followed you on HireClub"
    mail(to: @user.email, subject: @subject)
  end
  
end

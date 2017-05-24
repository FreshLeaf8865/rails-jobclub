class UserBadgeCreateActivity
  KEY = "user_badge.create"

  def self.get_recipients_for(activity)
    # don't create notification if you like your own stuff you douche
    recepients = [activity.trackable.user]
  end
end
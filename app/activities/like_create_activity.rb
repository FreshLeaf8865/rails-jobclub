class LikeCreateActivity
  KEY = "like.create"

  def self.get_recipients_for(activity)
    # don't create notification if you like your own stuff you douche
    recepients = [activity.trackable.likeable.user] if activity.owner != activity.trackable.likeable.user
  end
end
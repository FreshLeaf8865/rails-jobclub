class Follow < ActiveRecord::Base
  # Extensions
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" and "follower" interface
  belongs_to :followable, polymorphic: true
  counter_culture :followable, touch: true,
    column_name: proc {|model| model.blocked? ? nil : "followers_count_cache" },
    column_names: {
      ["follows.followable_type = ?", 'User'] => 'followers_count_cache',
      ["follows.followable_type = ?", 'Company'] => 'followers_count_cache',
    }

  belongs_to :follower,   polymorphic: true

  # Callbacks
  after_create :create_follow_activity
  after_destroy :create_unfollow_activity

  def create_follow_activity
    followable.create_activity_once :follow, owner: follower
  end

  def create_unfollow_activity
    followable.create_activity :unfollow, owner: follower, published: false
    activities = Activity.where(trackable_id: followable.id, trackable_type: followable.class.name, key: "#{followable.class.name.downcase}.follow")
    activities.update_all(published: false)
    notifications = Notification.where(activity_id: activities.pluck(:id))
    notifications.update_all(published: false)
    return true
  end

  def block!
    self.update_attribute(:blocked, true)
  end

end

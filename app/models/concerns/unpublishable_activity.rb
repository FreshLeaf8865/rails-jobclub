module UnpublishableActivity
  extend ActiveSupport::Concern

  included do
    before_destroy :unpublish_activities
  end
  
  def unpublish_activities
    activities = Activity.where(trackable_id: self.id, trackable_type: self.class.name)
    activities.update_all(published: false)
    notifications = Notification.where(activity_id: activities.pluck(:id))
    notifications.update_all(published: false)
    return true
  end

end

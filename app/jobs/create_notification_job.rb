class CreateNotificationJob < ApplicationJob
  queue_as :default

  def perform(activity_id)
    Notification.create_notifications_for_activity(activity_id) if Notification.enabled
  end
end

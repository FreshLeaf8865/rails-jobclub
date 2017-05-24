class PresenceChannel < ApplicationCable::Channel
  NAME = "presence"

  def subscribed
    stream_from NAME
    user_present
  end

  def unsubscribed
    user_inactive
    stop_all_streams
  end

  def user_present
    UserPresenceJob.perform_later(current_user.id, "active")
  end

  def user_inactive
    UserPresenceJob.perform_later(current_user.id, "inactive")
  end
end

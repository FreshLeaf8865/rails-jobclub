class UserPresenceJob < ApplicationJob
  queue_as :default

  def perform(user_id, event)
    ActionCable.server.broadcast PresenceChannel::NAME, { event: event, user_id: user_id}
  end
end

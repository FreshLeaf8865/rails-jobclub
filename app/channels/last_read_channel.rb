class LastReadChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update(data)
    conversation_user = current_user.conversation_users.find_by(conversation_id: data["conversation_id"])
    conversation_user.update_last_read_at
    TitleCountJob.perform_later(current_user)
  end
end

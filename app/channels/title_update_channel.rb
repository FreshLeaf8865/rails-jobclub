class TitleUpdateChannel < ApplicationCable::Channel
  def subscribed
    stream_from "Title Update:#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end

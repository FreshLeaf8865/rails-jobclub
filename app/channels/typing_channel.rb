class TypingChannel < ApplicationCable::Channel

  def subscribed
    current_user.conversations.find_each do |conversation|
      stream_from "typing:#{conversation.id}"
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def is_typing(data)
    ActionCable.server.broadcast "typing:#{data["conversation_id"]}", {
      is_typing: data["is_typing"],
      conversation_id: data["conversation_id"],
      user_id: current_user.id
    }
  end


end
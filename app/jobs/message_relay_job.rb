class MessageRelayJob < ApplicationJob
  queue_as :critical

  def perform(message)
    ActionCable.server.broadcast "conversations:#{message.conversation.id}", {
      conversation_id: message.conversation.id,
      user_id: message.user.id,
      message: message,
      message_partial: render_message(message),
      unread_message_hash: create_unread_msg_hash(message.conversation)
    }
  end

  private

  #hash containing users in conversation: user_id as key and thier unread message count as value
  def create_unread_msg_hash(conversation)
    hash = {}
    conversation.conversation_users.each do |conversation_user|
      hash[conversation_user.user_id] = conversation_user.unread_messages_count
    end
    hash
  end

  def render_message(message)
    MessagesController.render partial: 'messages/message', locals: {message: message, current_user: nil}
  end


end

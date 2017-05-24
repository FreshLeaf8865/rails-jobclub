class MessageRelayJob < ApplicationJob
  queue_as :critical

  def perform(message)
    ActionCable.server.broadcast "conversations:#{message.conversation.id}", {
      conversation_id: message.conversation.id,
      user_id: message.user.id,
      message: message,
      message_partial: render_message(message)
    }
  end

  private

  def render_message(message)
    MessagesController.render partial: 'messages/message', locals: {message: message, current_user: nil}
  end


end
class AddUnreadMessagesToConversationUser < ActiveRecord::Migration[5.0]
  def change
    add_column :conversation_users, :unread_messages_count, :integer, null: false, default: 0
  end
end

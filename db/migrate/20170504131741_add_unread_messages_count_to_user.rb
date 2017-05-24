class AddUnreadMessagesCountToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unread_messages_count, :integer, null: false, default: 0
  end
end

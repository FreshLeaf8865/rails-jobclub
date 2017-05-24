class AddLastReadAtToConversationUser < ActiveRecord::Migration[5.0]
  def change
    add_column :conversation_users, :last_read_at, :datetime
  end
end

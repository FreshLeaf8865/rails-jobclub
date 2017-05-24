class AddMessagesCountToConversations < ActiveRecord::Migration

  def change
    add_column :conversations, :messages_count, :integer, :null => false, :default => 0
  end

end

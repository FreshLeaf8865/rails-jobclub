class AddKeyToConversation < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :key, :citext

    add_index :conversations, :key, unique: true
  end
end

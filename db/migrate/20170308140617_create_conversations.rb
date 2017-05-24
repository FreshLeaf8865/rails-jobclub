class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.string :slug, null: false

      t.timestamps
    end

    add_index :conversations, :slug, unique: true
  end
end

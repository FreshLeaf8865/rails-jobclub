class CreateMentions < ActiveRecord::Migration[5.0]
  def change
    create_table :mentions do |t|
      t.references :user, foreign_key: true
      t.references :mentionable, polymorphic: true
      t.references :sender, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :mentions, [:user_id, :mentionable_type, :mentionable_id], unique: true, name: "user_mentions"
  end
end

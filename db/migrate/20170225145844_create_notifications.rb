class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :activity, foreign_key: true
      t.string :activity_key, null: false
      t.datetime :read_at
      t.boolean :published, null: false, default: true
      

      t.timestamps
    end

    add_index :notifications, :activity_key
    add_index :notifications, :read_at
    add_index :notifications, :published
    add_index :notifications, [:user_id, :activity_id], unique: true

  end
end

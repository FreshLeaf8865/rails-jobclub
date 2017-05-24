class CreateUserBadges < ActiveRecord::Migration[5.0]
  def change
    create_table :user_badges do |t|
      t.references :user, foreign_key: true
      t.references :badge, foreign_key: true

      t.timestamps
    end

    add_index :user_badges, [:user_id, :badge_id], unique: true
  end
end

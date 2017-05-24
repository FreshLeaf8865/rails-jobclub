class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :likeable, polymorphic: true

      t.timestamps
    end

    add_index :likes, [:user_id, :likeable_type, :likeable_id], unique: true
  end
end

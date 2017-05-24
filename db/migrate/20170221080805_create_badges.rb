class CreateBadges < ActiveRecord::Migration[5.0]
  def change
    create_table :badges do |t|
      t.citext :name, null: false
      t.citext :slug, null: false
      t.string :avatar_uid
      t.string :description
      t.string :earned_by

      t.timestamps
    end

    add_index :badges, :name, unique: true
    add_index :badges, :slug, unique: true
  end
end

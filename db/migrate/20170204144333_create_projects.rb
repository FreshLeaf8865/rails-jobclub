class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name
      t.citext :slug
      t.integer :position, null: false, default: 0
      t.string :image_uid
      t.string :image_name
      t.integer :image_width
      t.integer :image_height

      t.timestamps
    end

    add_index :projects, [ :user_id, :slug ], unique: true
  end
end

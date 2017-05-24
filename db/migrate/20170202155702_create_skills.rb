class CreateSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :skills do |t|
      t.string :name, null: false
      t.citext :slug, null: false

      t.timestamps
    end

    add_index :skills, :name, unique: true
    add_index :skills, :slug, unique: true
  end
end

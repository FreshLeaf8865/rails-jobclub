class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.citext :slug, null: false
      t.integer :users_count, null: false, default: 0

      t.timestamps
    end

    add_index :roles, :name, unique: true
    add_index :roles, :slug, unique: true
  end
end

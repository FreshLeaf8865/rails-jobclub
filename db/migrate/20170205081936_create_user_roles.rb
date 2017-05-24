class CreateUserRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_roles do |t|
      t.references :user, foreign_key: true
      t.references :role, foreign_key: true
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :user_roles, [:user_id, :role_id], unique: true
  end
end

class AddOpenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :open_to_remote, :boolean, null: false, default: false
    add_column :users, :open_to_full_time, :boolean, null: false, default: false
    add_column :users, :open_to_part_time, :boolean, null: false, default: false
    add_column :users, :open_to_contract, :boolean, null: false, default: false
    add_column :users, :open_to_internship, :boolean, null: false, default: false

    add_index :users, :open_to_remote
    add_index :users, :open_to_full_time
    add_index :users, :open_to_part_time
    add_index :users, :open_to_contract
    add_index :users, :open_to_internship
  end
end

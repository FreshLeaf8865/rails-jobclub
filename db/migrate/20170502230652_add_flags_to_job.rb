class AddFlagsToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :full_time, :boolean, null: false, default: true
    add_column :jobs, :part_time, :boolean, null: false, default: false
    add_column :jobs, :remote, :boolean, null: false, default: false
    add_column :jobs, :contract, :boolean, null: false, default: false
    add_column :jobs, :internship, :boolean, null: false, default: false

    add_index :jobs, :full_time
    add_index :jobs, :part_time
    add_index :jobs, :remote
    add_index :jobs, :contract
    add_index :jobs, :internship
  end
end

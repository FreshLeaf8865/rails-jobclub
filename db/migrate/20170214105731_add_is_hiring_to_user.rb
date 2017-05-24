class AddIsHiringToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_hiring, :boolean, null: false, default: false
    add_index  :users, :is_hiring
  end
end

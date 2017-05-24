class AddIsUsWorkAuthorizedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_us_work_authorized, :boolean
    add_index :users, :is_us_work_authorized
  end
end

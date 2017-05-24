class AddAvailableToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_available, :boolean, null: false, default: false

    add_index :users, :is_available
  end
end

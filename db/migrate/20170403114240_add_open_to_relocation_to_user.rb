class AddOpenToRelocationToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :open_to_relocation, :boolean, null: false, default: false
  end
end

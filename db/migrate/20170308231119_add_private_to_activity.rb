class AddPrivateToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :private, :boolean, null: false, default: false

    add_index :activities, :private
  end

end

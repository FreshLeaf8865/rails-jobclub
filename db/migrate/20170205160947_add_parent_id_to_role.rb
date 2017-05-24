class AddParentIdToRole < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :parent_id, :integer
  end
end

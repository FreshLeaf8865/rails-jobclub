class AddAddedByToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :added_by_id, :integer
    add_index :companies, :added_by_id
  end
end

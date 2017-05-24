class AddTagsToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :tags, :string, array: true, default: []
    add_index  :companies, :tags, using: 'gin'  
  end
end

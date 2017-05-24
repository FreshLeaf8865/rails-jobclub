class AddFacebookIdToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :facebook_id, :string
    add_index  :companies, :facebook_id, unique: true

  end
end

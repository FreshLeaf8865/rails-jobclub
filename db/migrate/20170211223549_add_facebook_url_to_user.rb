class AddFacebookUrlToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_url, :string
  end
end

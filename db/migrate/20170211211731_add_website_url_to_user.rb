class AddWebsiteUrlToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :website_url, :string
  end
end

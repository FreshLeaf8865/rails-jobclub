class AddTwitterUrlToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :twitter_url, :string
  end
end

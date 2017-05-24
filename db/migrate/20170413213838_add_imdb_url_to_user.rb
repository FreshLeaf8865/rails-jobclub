class AddImdbUrlToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :imdb_url, :string
  end
end

class AddMediumUrlToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :medium_url, :string
  end
end

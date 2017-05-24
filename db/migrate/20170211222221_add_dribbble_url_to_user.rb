class AddDribbbleUrlToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :dribbble_url, :string
  end
end

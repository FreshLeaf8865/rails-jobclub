class AddLikesCountToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :likes_count, :integer, :null => false, :default => 0
  end
end

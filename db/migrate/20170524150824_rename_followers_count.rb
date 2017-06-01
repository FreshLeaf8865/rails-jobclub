class RenameFollowersCount < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :followers_count, :followers_count_cache
    rename_column :companies, :followers_count, :followers_count_cache
  end
end

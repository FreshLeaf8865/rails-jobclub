class AddLikesCountToUserBadges < ActiveRecord::Migration

  def change
    add_column :user_badges, :likes_count, :integer, :null => false, :default => 0
  end

end

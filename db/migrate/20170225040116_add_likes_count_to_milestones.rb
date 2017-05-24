class AddLikesCountToMilestones < ActiveRecord::Migration

  def change
    add_column :milestones, :likes_count, :integer, :null => false, :default => 0
  end

end

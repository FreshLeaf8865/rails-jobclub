class AddLikesCountToProjects < ActiveRecord::Migration

  def change
    add_column :projects, :likes_count, :integer, :null => false, :default => 0
  end

end

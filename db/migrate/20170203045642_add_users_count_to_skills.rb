class AddUsersCountToSkills < ActiveRecord::Migration

  def up
    add_column :skills, :users_count, :integer, :null => false, :default => 0
  end

  def down
    remove_column :skills, :users_count
  end

end

class AddYearsExperienceToUsers < ActiveRecord::Migration

  def up
    add_column :users, :years_experience, :integer, :null => false, :default => 0
  end

  def down
    remove_column :users, :years_experience
  end

end

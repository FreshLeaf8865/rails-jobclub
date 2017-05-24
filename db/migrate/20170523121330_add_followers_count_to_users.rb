class AddFollowersCountToUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :followers_count, :integer, :null => false, :default => 0
    Company.find_each do |company|
      company.followers_count = company.followers.count
      company.save
    end

    User.find_each do |user|
      user.followers_count = user.followers.count
      user.save
    end
  end

  def down
    remove_column :users, :followers_count
  end
end

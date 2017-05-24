class AddFollowersCountToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :followers_count, :integer, :null => false, :default => 0
  end
end

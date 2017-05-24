class AddFacebookIdToMilestone < ActiveRecord::Migration[5.0]
  def change
    add_column :milestones, :facebook_id, :string

    add_index :milestones, :facebook_id, unique: true
  end
end

class AddDescriptionToMilestone < ActiveRecord::Migration[5.0]
  def change
    add_column :milestones, :description, :text
  end
end

class ChangeTitleToNameMilestone < ActiveRecord::Migration[5.0]
  def change
    rename_column :milestones, :title, :name
  end
end

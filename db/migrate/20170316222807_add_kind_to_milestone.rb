class AddKindToMilestone < ActiveRecord::Migration[5.0]
  def change
    add_column :milestones, :kind, :string, default: Milestone::WORK

    add_index :milestones, :kind
  end
end

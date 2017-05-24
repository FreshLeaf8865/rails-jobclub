class AddSkillsToMilestones < ActiveRecord::Migration[5.0]
  def change
    add_column :milestones, :skills, :string, array: true, default: []
    add_index  :milestones, :skills, using: 'gin'
  end
end

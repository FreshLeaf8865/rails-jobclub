class AddSkillsToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :skills, :string, array: true, default: []
    add_index  :projects, :skills, using: 'gin'
  end
end

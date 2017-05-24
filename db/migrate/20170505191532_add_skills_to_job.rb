class AddSkillsToJob < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :skills, :string, array: true, default: []
    add_index  :jobs, :skills, using: 'gin'
  end
end

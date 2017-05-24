class AddPositionToUserSkill < ActiveRecord::Migration[5.0]
  def change
    add_column :user_skills, :position, :integer, null: false, default: 0
  end
end

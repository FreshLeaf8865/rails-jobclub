class CreateUserSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :user_skills do |t|
      t.references :user, foreign_key: true
      t.references :skill, foreign_key: true
      t.integer :years, null: false, default: 0
      
      t.timestamps
    end

    add_index :user_skills, [:user_id, :skill_id], unique: true
  end
end

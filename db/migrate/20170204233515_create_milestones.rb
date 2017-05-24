class CreateMilestones < ActiveRecord::Migration[5.0]
  def change
    create_table :milestones do |t|
      t.references :user, foreign_key: true
      t.string :title, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.string :link

      t.timestamps
    end

    add_index :milestones, :start_date
  end
end

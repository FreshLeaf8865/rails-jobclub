class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string :name, null: false
      t.citext :slug, null: false
      t.references :company, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.text :description
      t.string :link

      t.timestamps
    end

    add_index :jobs, :slug, unique: true
  end
end

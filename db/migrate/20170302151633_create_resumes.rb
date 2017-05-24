class CreateResumes < ActiveRecord::Migration[5.0]
  def change
    create_table :resumes do |t|
      t.references :user, foreign_key: true
      t.string :file_uid
      t.string :file_name

      t.timestamps
    end
  end
end

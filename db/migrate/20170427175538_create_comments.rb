class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.integer :commentable_id
      t.string  :commentable_type
      t.text :text, null: false

      t.timestamps
    end
  end
end

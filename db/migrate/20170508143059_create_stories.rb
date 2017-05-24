class CreateStories < ActiveRecord::Migration[5.0]
  def change
    create_table :stories do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :cover_uid
      t.datetime :published_on
      t.text :content
      t.integer :likes_count, :null => false, :default => 0

      t.timestamps
    end
  end
end

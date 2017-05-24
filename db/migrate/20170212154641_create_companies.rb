class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.citext :slug, null: false
      t.string :avatar_uid
      t.string :logo_uid
      t.string :twitter_url
      t.string :facebook_url
      t.string :instagram_url
      t.string :angellist_url
      t.string :website_url
      t.string :tagline

      t.timestamps
    end

    add_index :companies, :slug, unique: true
  end
end

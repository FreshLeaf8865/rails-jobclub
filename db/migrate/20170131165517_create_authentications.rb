class CreateAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :authentications do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.references :user, foreign_key: true, null: false
      t.text :token
      t.text :refresh_token
      t.string :secret
      t.boolean :expires
      t.datetime :expires_at
      t.json :omniauth_json
      
      t.timestamps
    end

    add_index :authentications, [ :provider, :uid ], unique: true
    add_index :authentications, :provider
  end
end

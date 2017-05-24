class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.citext :slug, null: false
      t.string :level #city, state, country etc
      t.string :short #sfo, us, es
      t.integer :parent_id

      t.timestamps
    end

    add_index :locations, [:parent_id, :name], unique: true
    add_index :locations, [:parent_id, :slug], unique: true
    add_index :locations, :parent_id
  end
end

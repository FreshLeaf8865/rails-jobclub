class AddFacebookIdToLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :facebook_id, :string

    add_index :locations, :facebook_id, unique: true
  end
end

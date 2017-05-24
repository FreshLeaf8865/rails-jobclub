class ChangeProjectSlugIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :projects, [ :user_id, :slug ]
    add_index :projects, :slug, unique: true
  end
end

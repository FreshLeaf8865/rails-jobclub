class RequireNameForProjects < ActiveRecord::Migration[5.0]
  def change
    change_column :projects, :name, :string, null: false
    change_column :projects, :slug, :citext, null: false
  end
end

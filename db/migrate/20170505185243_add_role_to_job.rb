class AddRoleToJob < ActiveRecord::Migration[5.0]
  def change
    add_reference :jobs, :role, foreign_key: true
  end
end

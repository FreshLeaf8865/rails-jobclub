class AddLocationToJob < ActiveRecord::Migration[5.0]
  def change
    add_reference :jobs, :location, foreign_key: true, null: false
  end
end

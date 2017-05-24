class AddOpenToNewOpportunitiesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :open_to_new_opportunities, :boolean, null: false, default: false
  end
end

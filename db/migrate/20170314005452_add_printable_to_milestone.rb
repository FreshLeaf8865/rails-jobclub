class AddPrintableToMilestone < ActiveRecord::Migration[5.0]
  def change
    add_column :milestones, :printable, :boolean, default: true, null: false

    add_index :milestones, :printable
  end
end

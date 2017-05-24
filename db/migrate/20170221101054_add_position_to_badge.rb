class AddPositionToBadge < ActiveRecord::Migration[5.0]
  def change
    add_column :badges, :position, :integer, null: false, default: 0
  end
end

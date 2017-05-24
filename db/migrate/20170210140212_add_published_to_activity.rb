class AddPublishedToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :published, :boolean, null: false, default: true
    add_index  :activities, :published
  end
end

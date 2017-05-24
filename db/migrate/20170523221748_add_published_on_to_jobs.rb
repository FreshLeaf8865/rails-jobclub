class AddPublishedOnToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :published_on, :datetime
    add_index :jobs, :published_on
  end
end

class AddCompanyToMilestone < ActiveRecord::Migration[5.0]
  def change
    add_reference :milestones, :company, foreign_key: true
  end
end

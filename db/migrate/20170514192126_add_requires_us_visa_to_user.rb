class AddRequiresUsVisaToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :requires_us_visa_sponsorship, :boolean
    add_index :users, :requires_us_visa_sponsorship
  end
end

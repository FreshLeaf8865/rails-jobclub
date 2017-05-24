class AddUsernameToAuthentication < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :username, :string
  end
end

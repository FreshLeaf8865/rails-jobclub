class AddAvatarUidToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :avatar_uid, :string
  end
end

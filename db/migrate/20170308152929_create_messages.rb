class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true
      t.references :conversation, foreign_key: true
      t.string :text, null: false

      t.timestamps
    end
  end
end

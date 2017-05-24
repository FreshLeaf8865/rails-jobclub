class CreateReviewRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :review_requests do |t|
      t.references :user, foreign_key: true, null: false
      t.text :goal, null: false

      t.timestamps
    end
  end
end

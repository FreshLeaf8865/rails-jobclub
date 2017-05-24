class UserRole < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  counter_culture :role, column_name: :users_count, touch: true
  acts_as_list scope: :user, top_of_list: 0
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Scopes
  scope :by_position, -> { order(position: :asc) }

  # Associations
  belongs_to :user
  belongs_to :role
  delegate :name, to: :role
  
  # Validations
  validates :user, presence: true
  validates :role, presence: true
  validates :role_id, uniqueness: { scope: :user_id }
end

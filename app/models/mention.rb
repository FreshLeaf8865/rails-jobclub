class Mention < ApplicationRecord
  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.sender }, recipient: Proc.new{ |controller, model| model.user }

  # Associations
  belongs_to :user
  belongs_to :sender, class_name: 'User'
  belongs_to :mentionable, polymorphic: true#, counter_cache: true
  

  # Validations
  validates_presence_of :mentionable_id
  validates_presence_of :mentionable_type
  validates_presence_of :user_id
  validates_presence_of :sender_id
  validates :user_id, uniqueness: { scope: [:mentionable_id, :mentionable_type]}
end

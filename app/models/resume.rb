class Resume < ApplicationRecord
  # Extensions
  dragonfly_accessor :file
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  # Scopes
  scope :by_newest,     -> { order(created_at: :desc)}

  # Associations
  belongs_to :user

  # Validations
  validates_presence_of :user
  validates_presence_of :file
  validates_size_of :file, maximum: 5.megabytes
end

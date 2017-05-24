class ReviewRequest < ApplicationRecord
  # Extensions
  is_impressionable
  include UnpublishableActivity
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }

  # Associations
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  # Validations
  validates :user, presence: true
  validates_length_of :goal, minimum: 10

  def status
    if comments.any?
      "Started"
    elsif self.impressions.where.not(user_id: user.id).any?
      "Viewed"
    else
      "Waiting for Review"
    end
  end

  def name
    "review request"
  end
end

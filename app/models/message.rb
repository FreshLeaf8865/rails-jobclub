class Message < ApplicationRecord
  # Extensions
  include UnpublishableActivity
  include PublicActivity::CreateActivityOnce
  include PublicActivity::Model
  tracked only: [:create], owner: Proc.new{ |controller, model| model.user }, private: true

  # Scopes
  scope :by_recent, -> {order(created_at: :asc)}

  # Associations
  belongs_to :user
  belongs_to :conversation
  counter_culture :conversation, touch: true

  # Validations
  validates :user, presence: true
  validates :conversation, presence: true
  validates :text, presence: true

  def read_by!(read_by_user)
    return if read_by_user == user
    self.create_activity_once key: MessageReadActivity::KEY, owner: read_by_user, published: false, private: true, recipient: conversation
  end

  def is_read?
    activities.where(key: MessageReadActivity::KEY).any?
  end

  def is_read_by?(read_by_user)
    activities.where(key: MessageReadActivity::KEY, owner: read_by_user).any?
  end
end

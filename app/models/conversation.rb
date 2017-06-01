class Conversation < ApplicationRecord
  # Extensions
  extend FriendlyId
  friendly_id :slug

  # Scopes
  scope :by_recent, -> {order(updated_at: :desc)}

  # Associations
  has_many :messages, dependent: :destroy
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users

  # Validations
  validates :slug, :uniqueness => true, :presence => true
  validates :key, uniqueness: {case_sensitive: false}, :allow_blank => true

  # Callbacks
  before_validation :ensure_slug, on: :create
  before_validation :update_key

  def ensure_slug
    if slug.blank?
      self.slug = loop do
        slug = SecureRandom.hex(8)
        break slug unless Conversation.where(slug: slug).exists?
      end
    end
  end

  def update_key
    self.key = Conversation.key_for_users(self.users)
  end

  def other_users(user)
    self.users - [user]
  end

  def last_message
    messages.by_recent.last
  end

  def unread_messages_count(user)
    conversation_users.where(user: user).first.try(:unread_messages_count)
  end

  def self.key_for_users(users)
    users.sort.map(&:id).join("_")
  end

  def self.between(users)
    key = self.key_for_users(users)

    conversation = Conversation.where(key: key).first_or_create
    conversation.users = users
    conversation.save
    return conversation
  end

  def update_unread_counts
    conversation_users.each do |conversation_user|
      conversation_user.update_unread_messages_count
    end
  end
end

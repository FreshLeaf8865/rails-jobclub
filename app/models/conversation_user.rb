class ConversationUser < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  # Validations
  validates :user_id, uniqueness: { scope: :conversation_id }

  def update_unread_messages_count
    self.unread_messages_count =  other_messages.count - read_activities.count
    self.save
  end

  def other_messages
    conversation.messages.where.not(user: user)
  end

  def activities
    Activity.where(recipient: conversation).where(owner: user)
  end

  def read_activities
    activities.where(key: MessageReadActivity::KEY)
  end

  def update_last_read_at
    read_at = Time.zone.now
    update(last_read_at: read_at)
    other_messages.where("created_at < ?", read_at).find_each do |message|
      message.read_by!(user)
    end
    conversation.update_unread_counts
  end

end

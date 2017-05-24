module ActsAsLikeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, class_name: "Like", as: :likeable, dependent: :destroy
  end

  def likeable?
    true
  end
  
  def liked?
    likes.any?
  end

  def liked_by?(user)
    likes.where(user: user).any?
  end

  def like_for(user)
    likes.where(user: user).first
  end

  def like!(user)
    likes.where(user: user).first_or_create.persisted?
  end

  def unlike!(user)
    likes.where(user: user).destroy_all
    return false
  end

  def toggle_like!(user)
    if !liked_by?(user)
      like!(user) 
    else
      unlike!(user)
    end
  end
end

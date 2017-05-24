class ConversationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.conversations
      else
        scope.none
      end
    end
  end

  def show?
    record.users.include?(user)
  end

  def between?
    return false if user.nil?
    true
  end

  def create?
    return false if user.nil?
    user.is_admin || user.is_moderator
  end
  
  def update?
    return false if user.nil?
    record.users.include?(user)
  end

  def destroy?
    return false if user.nil?
    record.users.include?(user)
  end
end

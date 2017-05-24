class StoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.stories
      else
        scope.published
      end
    end
  end

  def show?
    return true if record.published?
    user.present? && (record.user == user || user.is_admin)
  end

  def create?
    return false if user.nil?
    true
  end
  
  def update?
    return false if user.nil?
    record.user == user || user.is_admin
  end

  def destroy?
    return false if user.nil?
    record.user == user
  end

  def publish?
    return false if user.nil?
    record.user == user || user.is_admin
  end
end

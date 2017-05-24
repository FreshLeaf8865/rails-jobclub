class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    return true
  end

  def create?
    return false if user.nil?
    return true
  end
  
  def update?
    return false if user.nil?
    record.user == user || user.is_admin
  end

  def destroy?
    return false if user.nil?
    record.user == user || user.is_admin || record.commentable.user == user
  end

  def like?
    return false if user.nil?
    return true
  end

  def unlike?
    return false if user.nil?
    return true
  end
end

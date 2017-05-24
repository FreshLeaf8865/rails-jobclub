class ReviewRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    return false if user.nil?
    user.is_reviewer || user.is_admin || record.user == user
  end

  def create?
    return false if user.nil?
    true
  end
  
  def update?
    return false if user.nil?
    user.is_reviewer || user.is_admin || record.user == user
  end

  def destroy?
    return false if user.nil?
    user.is_admin || record.user == user
  end
end

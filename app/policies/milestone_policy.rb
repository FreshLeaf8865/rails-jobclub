class MilestonePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.milestones
      else
        scope.none
      end
    end
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
end

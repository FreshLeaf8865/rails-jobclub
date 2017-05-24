class UserRolePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user
        user.user_roles
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
    record.user == user
  end

  def destroy?
    return false if user.nil?
    record.user == user
  end
end

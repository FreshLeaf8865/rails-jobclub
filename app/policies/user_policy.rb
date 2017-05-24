class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    true
  end
  
  def update?
    return false if user.nil?
    record == user || user.is_admin
  end

  def destroy?
    return false if user.nil?
    record == user || user.is_admin
  end
end

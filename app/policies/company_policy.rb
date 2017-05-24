class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    return false if user.nil?
    user.is_moderator || user.is_admin
  end
  
  def update?
    return false if user.nil?
    user.is_moderator || user.is_admin
  end

  def destroy?
    return false if user.nil?
    user.is_admin
  end

  def refresh?
    return false if user.nil?
    user.is_moderator || user.is_admin
  end

  def import?
    return false if user.nil?
    user.is_moderator || user.is_admin
  end

  def follow?
    true
  end

  def unfollow?
    return false if user.nil?
    true
  end
end

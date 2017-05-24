class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protect_from_forgery with: :exception



  def after_sign_in_path_for(user)
    if user.onboarded?
      stored_location_for(:user) || root_path
    else
      return onboarding_index_path
    end
  end

  def sign_up_required
    redirect_to new_user_registration_url unless user_signed_in?
  end

  def store_location(path)
    store_location_for(:user, path)
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end

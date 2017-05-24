class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  
  def facebook
    if request.env["omniauth.auth"].info.email.blank?
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
    else
      authorize("facebook")
    end
  end

  def linkedin
    authorize("linkedin")
  end

  def google_oauth2
    authorize("google_oauth2")
  end

  def authorize(provider)
    omniauth = request.env["omniauth.auth"]
    
    # always set omniauth in session
    session["devise.omniauth"] = omniauth

    Rails.logger.info omniauth.to_json

    @user = User.from_omniauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => provider) if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end

  end
end

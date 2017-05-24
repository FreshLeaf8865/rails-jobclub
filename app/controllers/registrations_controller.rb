class RegistrationsController < Devise::RegistrationsController

  def sign_up_params
    params.require(:user).permit(:name, :email, :password)
  end

  def account_update_params
    params.require(:user).permit(:username, :name, :email, :password, :avatar, :retained_avatar, :remove_avatar, 
      :location_id, :company_id, :bio,
      :is_available, :is_hiring, :is_reviewer,
      :open_to_remote, :open_to_full_time, :open_to_part_time, :open_to_contract, :open_to_internship, :open_to_relocation, :open_to_new_opportunities,
      :is_us_work_authorized, :requires_us_visa_sponsorship,
      :website_url, :twitter_url, :dribbble_url, :github_url, :medium_url, :facebook_url, :linkedin_url, :instagram_url, :imdb_url)
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end
end

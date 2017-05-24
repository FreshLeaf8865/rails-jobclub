class OnboardingController < ApplicationController
  include Wicked::Wizard
  before_action :sign_up_required
  layout "minimal"

  steps :username, :location, :status, :roles, :skills, :milestones

  def show
    @user = current_user
    case step
    when :roles
      unless @user.user_roles.any?
        @user.user_roles.build
      end
    when :skills
      @user.user_skills.build if @user.user_skills.empty?
    when :milestones
      @user.milestones.build if @user.milestones.empty?
    end

    render_wizard
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)
    render_wizard @user
  end

  def finish_wizard_path
    return user_path(current_user)
  end

  def user_params
    params.require(:user).permit(:name, :username, :location_id, :company_id,
      :is_available, :is_hiring,
      :open_to_remote, :open_to_full_time, :open_to_part_time, :open_to_contract, :open_to_internship, :open_to_relocation,
      :is_us_work_authorized, :requires_us_visa_sponsorship,
      user_roles_attributes: [:id, :role_id], 
      user_skills_attributes: [:id, :skill_id, :years, :_destroy],
      milestones_attributes: [:id, :name, :start_date, :_destroy])
  end
end

module UserHelper
  def next_user_completion_path(user_completion)
    step = user_completion.next_step
    case step
    when UserCompletion::USERNAME_STEP
      edit_user_registration_path
    when UserCompletion::LOCATION_STEP
      edit_user_registration_path
    when UserCompletion::BIO_STEP
      edit_user_registration_path
    when UserCompletion::AVATAR_STEP
      edit_user_registration_path
    when UserCompletion::ROLES_STEP
      new_user_role_path
    when UserCompletion::SKILLS_STEP
      new_user_skill_path
    when UserCompletion::MILESTONES_STEP
      new_milestone_path
    when UserCompletion::PROJECTS_STEP
      new_project_path
    when UserCompletion::WEBSITE_STEP
      edit_user_registration_path
    end 
  end

  def display_years(years)
    return pluralize(years, "Year") if years < 11
    return "10+ Years"
  end

  def viewing_self?(user)
    current_user == user
  end

  def is_admin?
    user_signed_in? && current_user.is_admin
  end

end

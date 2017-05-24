
class UserCompletion
  attr_accessor :user, :link, :percent
  
  USERNAME_STEP = "Set Username"
  LOCATION_STEP = "Set Location"
  BIO_STEP = "Add Bio"
  AVATAR_STEP = "Upload Profile Image"
  ROLES_STEP = "Add Roles"
  SKILLS_STEP = "Add Skills"
  PROJECTS_STEP = "Add Projects"
  MILESTONES_STEP = "Add Milestones"
  WEBSITE_STEP = "Add Web Links"

  def initialize(user)
    @user = user
  end

  def percent_complete
    percent = 0

    percent += 10 if user.username.present?

    percent += 10 if user.location.present?

    percent += 10 if user.bio.present?

    percent += 10 if user.avatar_stored?

    percent += 10 if roles_complete?

    percent += 10 if skills_complete?

    percent += 10 if projects_complete?

    percent += 10 if milestones_complete?

    percent += 10 if has_one_url?

    percent

  end

  def roles_complete?
    user.roles.any?
  end

  def skills_complete?
    user.skills.count >= 5
  end

  def milestones_complete?
    user.milestones.count >= 5
  end

  def projects_complete?
    user.projects.count >= 3
  end

  def has_one_url?
    user.website_url.present? || user.linkedin_url.present? || user.twitter_url.present? || user.dribbble_url.present? || user.facebook_url.present? || user.github_url.present? || user.medium_url.present?
  end

  def has_bio?
    user.bio.present?
  end

  def has_resume?
    user.resumes.any?
  end

  def can_request_review?
    roles_complete? && skills_complete? && milestones_complete? && has_bio? && has_resume?
  end

  def next_step
    return USERNAME_STEP if user.username.blank?
    return LOCATION_STEP if user.location.blank?
    return BIO_STEP if user.bio.blank?
    return AVATAR_STEP if user.avatar.blank?
    return ROLES_STEP if !roles_complete?
    return SKILLS_STEP if !skills_complete?
    return PROJECTS_STEP if !projects_complete?
    return MILESTONES_STEP if !milestones_complete?
    return WEBSITE_STEP if !has_one_url?
  end

end

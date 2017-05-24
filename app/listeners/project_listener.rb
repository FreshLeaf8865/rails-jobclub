class ProjectListener
  def update_project(project)
    user = project.user
    return unless user.present?

    if user.projects.count >= 3
      Badge.reward_project_badge(user)
    end
  end
end
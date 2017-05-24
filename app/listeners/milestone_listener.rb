class MilestoneListener
  def update_milestone(milestone)
    user = milestone.user
    return unless user.present?

    if user.milestones.count >= 5
      Badge.reward_milestone_badge(user)
      if user.milestones.count >= 10
        Badge.reward_milehigh_badge(user)
      end
    end
  end
end
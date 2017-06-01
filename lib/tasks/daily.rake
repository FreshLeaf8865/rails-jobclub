namespace :daily do
  desc "run daily tasks"
  task run: :environment do
    User.counter_culture_fix_counts
    UserSkill.counter_culture_fix_counts
    UserRole.counter_culture_fix_counts
    Badge.check_badges
    Project.privatize_projects_without_image
    Follow.counter_culture_fix_counts
  end
  
end

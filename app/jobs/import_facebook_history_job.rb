class ImportFacebookHistoryJob < ApplicationJob
  queue_as :default

  def perform(user, omniauth)
    education = omniauth["extra"]["raw_info"]["education"]
    user.import_education_from_facebook(education)
    
    work = omniauth["extra"]["raw_info"]["work"]
    user.import_work_from_facebook(work)

    location = omniauth["extra"]["raw_info"]["location"]

    Location.import_facebook_id(location["id"])
  end
end

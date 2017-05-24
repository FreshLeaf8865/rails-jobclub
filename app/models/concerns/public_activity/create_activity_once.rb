module PublicActivity::CreateActivityOnce
  extend ActiveSupport::Concern

  def create_activity_once(*args)
    options = prepare_settings(*args).except(:parameters).merge(trackable: self)

    if PublicActivity::Activity.where(options).empty?
      create_activity(*args)
    end
  end
end

FactoryGirl.define do
  factory :notification do
    activity { FactoryGirl.create(:activity) }
    activity_key "like.create"
    user
  end
end

FactoryGirl.define do
  factory :activity do
    trackable { FactoryGirl.create(:like) }
    owner     { FactoryGirl.create(:user) }
    key       "like.create"
  end
end
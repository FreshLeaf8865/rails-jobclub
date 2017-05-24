FactoryGirl.define do
  factory :like do
    user
    likeable { FactoryGirl.create(:project) }
  end
end

FactoryGirl.define do
  factory :skill do
    name { FactoryGirl.generate(:name) }
  end
end

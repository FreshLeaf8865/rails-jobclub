FactoryGirl.define do
  factory :location do
    name  { FactoryGirl.generate(:city) }
    level Location::CITY
  end
end

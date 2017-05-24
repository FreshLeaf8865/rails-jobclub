FactoryGirl.define do
  factory :badge do
    name { FactoryGirl.generate(:company_name) }
  end
end

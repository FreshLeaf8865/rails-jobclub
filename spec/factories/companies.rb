FactoryGirl.define do
  factory :company do
    name { FactoryGirl.generate(:company_name) }
  end
end

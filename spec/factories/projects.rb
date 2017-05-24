FactoryGirl.define do
  factory :project do
    name { FactoryGirl.generate(:company_name) }
    user
    image { File.new("#{Rails.root}/spec/support/fixtures/image.png") }
  end
end

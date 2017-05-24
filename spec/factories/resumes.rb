FactoryGirl.define do
  factory :resume do
    user
    file { File.new("#{Rails.root}/spec/support/fixtures/image.png") }
  end
end

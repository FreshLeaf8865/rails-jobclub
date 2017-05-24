FactoryGirl.define do
  factory :message do
    user
    conversation
    text "My Message"
  end
end

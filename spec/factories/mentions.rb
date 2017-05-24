FactoryGirl.define do
  factory :mention do
    user
    sender { FactoryGirl.create(:user) }
    mentionable { FactoryGirl.create(:comment) }
  end
end

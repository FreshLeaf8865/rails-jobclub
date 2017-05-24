FactoryGirl.define do
  factory :user do
    email { FactoryGirl.generate(:email) }
    name { FactoryGirl.generate(:name) }
    password "testtest"
    password_confirmation {|u| u.password }    

    factory :admin do
      after(:build) {|user| user.is_admin = true }
    end

    factory :moderator do
      after(:build) {|user| user.is_moderator = true }
    end

    factory :reviewer do
      after(:build) {|user| user.is_reviewer = true }
    end
  end
end

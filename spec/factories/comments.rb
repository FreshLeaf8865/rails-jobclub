FactoryGirl.define do
  factory :comment do
    user
    commentable { FactoryGirl.create(:milestone)}
    text "My Comment"
  end
end

FactoryGirl.define do
  factory :authentication do
    user
    provider "facebook"
    uid "test"

    trait :kidbombay do
      provider 'facebook'
      uid '10158109415805244'
      token 'EAAROPfhGmSQBAJVhoJl5DnKwZB7Ce8y98tz2MUxVVGOflOWd2Itsr4KIskCAB2ggZBUb1yJEZBBF0d63ZAgzncCdGrZCzgZCz23KKvKuxS3AK4m6xuxzO9vYJQEsZCRRl4ZBRBOmU0nRZA3F1Yfd6SKmZByBROtIoOeMEZD'
    end
  end
end

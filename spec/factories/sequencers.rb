FactoryGirl.define do

  sequence :email do |n|
    "#{Faker::Internet.user_name}_#{n}@#{Faker::Internet.domain_name}"
  end

  sequence :name do |n|
    "#{Faker::Name.name}"
  end

  sequence :username do |n|
    "#{Faker::Internet.user_name}_#{n}"
  end

  sequence :company_name do |n|
    "#{Faker::Company.name}_#{n}"
  end

  sequence :city do |n|
    "#{Faker::Address.city}_#{n}"
  end

  sequence :url do |n|
    "#{Faker::Internet.url}_#{n}"
  end

  sequence :title do |n|
    "#{Faker::Lorem.sentence}_#{n}"
  end
  
  sequence :bitcoin_address do |n|
    "#{Faker::Bitcoin.address}_#{n}"
  end

  sequence :phone do |n|
    "1415555#{n}".ljust(11, '0')
  end

  sequence :password do |n|
    "Testtest#{n}"
  end
end

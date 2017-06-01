require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  subject { user }

  describe "associations" do
    it { should have_many(:conversation_users) }
    it { should have_many(:conversations).through(:conversation_users) }
    it { should have_many(:notifications) }
    it { should have_many(:authentications) }
    it { should have_many(:projects) }
    it { should have_many(:milestones) }
    it { should have_many(:resumes) }
    it { should have_many(:review_requests) }
    it { should have_many(:companies).through(:milestones) }
    it { should have_many(:user_skills) }
    it { should have_many(:skills).through(:user_skills) }

    it { should have_many(:user_roles) }
    it { should have_many(:roles).through(:user_roles) }

    it { should have_many(:user_badges) }
    it { should have_many(:badges).through(:user_badges) }

    it { should belong_to(:location)}
    it { should belong_to(:company)}

    it { should have_many(:likes) }
    it { should have_many(:jobs) }
    it { should have_many(:stories) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:username).is_at_least(0).is_at_most(50) }

    it "should not allow invalid usernames" do
      # from route recognizers
      invalid_usernames = ["assets", "about","contact", "admin"]
      invalid_usernames += ["!","#","test name"]
      invalid_usernames.each do |username|
        user.username = username
        expect(user.valid?).to eq(false)
      end
    end

    it { is_expected.to allow_value("test.name", "5", "test_name", "test-name").for(:username) }
  end

  # describe "omniauth" do
  #   it "should import omniauth data from facebook" do
  #     Location.import_cities
  #     json = '{"provider":"facebook","uid":"643675243","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/v2.6/643675243/picture?type=large","location":"San Francisco, California"},"credentials":{"token":"EAACiIAGQWrYBAKDtZB5XJwSH5nwuRheTxOZBP6LXAoBjHxZBbWqfVMkZBRE8DDTXh2aa1ODVFAtCkW8TVlNZAlwALfuUT0S71m71oksuja4JaAws7DETGjUhcFGZBLCt6gZAOLMrWSgOKUWPLeGpb4R20mDUoP3w0EZD","expires_at":1491352014,"expires":true},"extra":{"raw_info":{"id":"643675243","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"}}}}'
  #     omniauth = JSON.parse(json)

  #     user = User.from_omniauth(omniauth)

  #     expect(user).to be_valid
  #     expect(user).to be_persisted

  #     expect(user.email).to eq("fire@kidbombay.com")
  #     expect(user.name).to eq("Ketan Anjaria")
  #     expect(user.gender).to eq("male")
  #     expect(user.location).to be_present

  #     auth = user.authentications.first
  #     expect(auth).to be_present
  #     expect(auth).to be_valid
  #     expect(auth).to be_persisted

  #   end

  #   it "should import omniauth data from google" do
  #     Location.import_cities
  #     json = '{"provider":"google_oauth2","uid":"117870559098729164650","info":{"name":"Ketan Anjaria","email":"ketan@hireclub.co","first_name":"Ketan","last_name":"Anjaria","image":"https://lh6.googleusercontent.com/-PlAu4YWJD9g/AAAAAAAAAAI/AAAAAAAAAAo/lu_q8Cr6Zio/photo.jpg"},"credentials":{"token":"ya29.GlsfBGTyLd8ZZj69NzeAAP54OGgY2H6MK1lA8K78_fqcu5A5LEc2PgkDF6cc5EUo7m15Ixgj_Nl7b1fFawdlY-TeCcd3LCuR6CE2xchJl6GWE9rEFujUf3HvaOoO","refresh_token":"1/r8d6rGKRblZ_Gjg2Ya2JqgYBsHEzaVNPUgkOxHZPnd1RTW3pRjENc5kHk6IEQevY","expires_at":1490978576,"expires":true},"extra":{"id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjdjODNmNWNjMTUzNjAwMzczN2MzNzU5YjJiOTBiMWE1ZDFkNGFjNjUifQ.eyJhenAiOiI0NDA3NjY5MjIwNC05ajI1NWVvYWNydTA0ZmlndW9hbmhvOTgzZzFxNHNiNi5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjQ0MDc2NjkyMjA0LTlqMjU1ZW9hY3J1MDRmaWd1b2FuaG85ODNnMXE0c2I2LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTE3ODcwNTU5MDk4NzI5MTY0NjUwIiwiaGQiOiJoaXJlY2x1Yi5jbyIsImVtYWlsIjoia2V0YW5AaGlyZWNsdWIuY28iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IjNnRGZrcXRSd2RPMGtqUk5QaXJnSGciLCJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiaWF0IjoxNDkwOTc0OTc3LCJleHAiOjE0OTA5Nzg1Nzd9.dwayt4BmV9Qkyf9ZCTv3hBxz_tsoE-jb7e1QS7_TugRCrRUA6qVGu5GMFO8z_lK0Bqi8jWwUzsz-a9o11mhPTawaAInVyQhgs6b2iIgGGjiT1OYjrVRpCtB3GJEqAGPhtytskyms0oTKyVfwots_KUXIpfAiJOCtK8EWERp8GQqYooEBZq7g7P0Q4TPQL3-A75zJiIVqNv62MgZaDyr8d9hP2tAMWctq5579XxayP2xjBsVDeElgFnoAt-OTHUlOXMqoS2ba3K1n_JdfA1p2jIGaAOfY2inqa4qUTJl6Vqdjh7IeJ7AwfmHPolBJwfp7qynNqRW4SG6UGzsLVXb8xQ","id_info":{"azp":"44076692204-9j255eoacru04figuoanho983g1q4sb6.apps.googleusercontent.com","aud":"44076692204-9j255eoacru04figuoanho983g1q4sb6.apps.googleusercontent.com","sub":"117870559098729164650","hd":"hireclub.co","email":"ketan@hireclub.co","email_verified":true,"at_hash":"3gDfkqtRwdO0kjRNPirgHg","iss":"accounts.google.com","iat":1490974977,"exp":1490978577},"raw_info":{"kind":"plus#personOpenIdConnect","sub":"117870559098729164650","name":"Ketan Anjaria","given_name":"Ketan","family_name":"Anjaria","picture":"https://lh6.googleusercontent.com/-PlAu4YWJD9g/AAAAAAAAAAI/AAAAAAAAAAo/lu_q8Cr6Zio/photo.jpg?sz=50","email":"ketan@hireclub.co","email_verified":"true","locale":"en","hd":"hireclub.co"}}}'
  #     omniauth = JSON.parse(json)

  #     user = User.from_omniauth(omniauth)

  #     expect(user).to be_valid
  #     expect(user).to be_persisted

  #     expect(user.email).to eq("ketan@hireclub.co")
  #     expect(user.name).to eq("Ketan Anjaria")
  #     expect(user.avatar_uid).to be_present

  #     auth = user.authentications.first
  #     expect(auth).to be_present
  #     expect(auth).to be_valid
  #     expect(auth).to be_persisted

  #   end

  #   it "should import work history" do
  #     json = '{"provider":"facebook","uid":"10158109415805244","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/v2.6/10158109415805244/picture?type=large","location":"San Francisco, California"},"credentials":{"token":"EAAROPfhGmSQBAI9Oaml4A3VSGo9jqaYxIn6MBGwyNpdoyY8JqSHO5dZAREh9HA3PFiOIZAO1K93WeJUQRTicRhgX5eOKxQRlbVKtRbGXqWgl0MfD2gJH33AGWqPF4O24h9usEtddBk98G6Wac6ZB9fyJCMvOMIZD","expires_at":1494876966,"expires":true},"extra":{"raw_info":{"id":"10158109415805244","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"},"education":[{"school":{"id":"111584518860183","name":"West Springfield High"},"type":"High School","year":{"id":"137409666290034","name":"1995"},"id":"10150413024980244"},{"concentration":[{"id":"108170975877442","name":"Photography"}],"school":{"id":"32359482111","name":"The Evergreen State College"},"type":"College","year":{"id":"143018465715205","name":"2000"},"id":"10158330373725244"}],"work":[{"description":"Untz Untz UntZ","employer":{"id":"821365304544508","name":"Up All Night SF"},"location":{"id":"114952118516947","name":"San Francisco, California"},"position":{"id":"106275566077710","name":"Chief technology officer"},"start_date":"2014-09-30","id":"10156584882275244"},{"employer":{"id":"1412288385651374","name":"HireClub"},"position":{"id":"849873341726582","name":"Founder"},"start_date":"2011-12-31","id":"10157862976510244"},{"employer":{"id":"294554919629","name":"kidBombay"},"position":{"id":"130875350283931","name":"CEO \u0026 Founder"},"start_date":"1999-12-01","id":"10150413024965244"},{"description":"Lead all branding and design. Kicked ass.","end_date":"2013-10-15","employer":{"id":"265831417137","name":"Samba TV"},"location":{"id":"114952118516947","name":"San Francisco, California"},"position":{"id":"248173885259874","name":"Design Director"},"start_date":"2013-02-01","id":"10153326054595244"},{"end_date":"2013-03-01","employer":{"id":"490553880961257","name":"Network"},"location":{"id":"114952118516947","name":"San Francisco, California"},"position":{"id":"130875350283931","name":"CEO \u0026 Founder"},"start_date":"2012-07-01","id":"10151920581535244"},{"description":"Create \u0026 Share Digital Business Cards","end_date":"2013-03-01","employer":{"id":"172171216175008","name":"CardFlick"},"location":{"id":"114952118516947","name":"San Francisco, California"},"position":{"id":"107957955904825","name":"Founder (company)"},"start_date":"2011-05-01","id":"10150644885265244"}]}}}'
  #     omniauth = JSON.parse(json)

  #     user = User.from_omniauth(omniauth)

  #     expect(user).to be_valid
  #     expect(user).to be_persisted

  #     ImportFacebookHistoryJob.perform_now(user, omniauth)
      
  #     milestone = user.milestones.work.first
  #     expect(milestone).to be_present
  #     expect(milestone.name).to eq "Joined Up All Night SF as Chief technology officer"
  #     expect(milestone.start_date.year).to eq 2014
  #     expect(milestone.start_date.month).to eq 9
  #     expect(milestone.start_date.day).to eq 30
  #     expect(milestone.facebook_id).to eq "10156584882275244"
  #     expect(milestone.description).to eq "Untz Untz UntZ"
  #     expect(milestone.kind).to eq Milestone::WORK
  #   end

  #   it "should import education history" do
  #     json = '{"provider":"facebook","uid":"10158109415805244","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/v2.6/10158109415805244/picture?type=large","location":"San Francisco, California"},"credentials":{"token":"EAAROPfhGmSQBAHf1NByZABYZCZAPIkQiJZA7WWHJt64OMBYHGGAoh9ernefABeKnkyz5KfwzIF8QtesIhJ5ux0vun8vm42IDd8UA22nttCnOxB1OUDNhSFymgOGqAQDpLUoZB7jWneEEZBs1eWacAHyZB0a8bg5sdAZD","expires_at":1494876966,"expires":true},"extra":{"raw_info":{"id":"10158109415805244","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"},"education":[{"school":{"id":"111584518860183","name":"West Springfield High"},"type":"High School","year":{"id":"137409666290034","name":"1995"},"id":"10150413024980244"},{"concentration":[{"id":"108170975877442","name":"Photography"}],"school":{"id":"32359482111","name":"The Evergreen State College"},"type":"College","year":{"id":"143018465715205","name":"2000"},"id":"10158330373725244"}]}}}'
  #     omniauth = JSON.parse(json)

  #     user = User.from_omniauth(omniauth)

  #     expect(user).to be_valid
  #     expect(user).to be_persisted

  #     ImportFacebookHistoryJob.perform_now(user, omniauth)
      
  #     milestone = user.milestones.education.last
  #     expect(milestone).to be_present
  #     expect(milestone.name).to eq "Went to The Evergreen State College"
  #     expect(milestone.start_date.year).to eq 2000
  #     expect(milestone.facebook_id).to eq "10158330373725244"
  #     expect(milestone.kind).to eq Milestone::EDUCATION
  #   end

  #   it "should import omniauth data from linkedin" do
  #     json = '{"provider":"linkedin","uid":"Fs7-zkSDyL","info":{"name":"Ketan Anjaria","email":"fire@kidbombay.com","nickname":"Ketan Anjaria","first_name":"Ketan","last_name":"Anjaria","location":{"country":{"code":"us"},"name":"San Francisco Bay Area"},"description":"CTO at Up All Night SF","image":"https://media.licdn.com/mpr/mprx/0_x6Xd1PH12k5_nYR3n6tFUXq-eKEYzxw3VGObv62-D8d0K7VgpGtW493-7n6Snfs3n6tWZPCt53Ix1U5g9v3zRb_Yh3IO1UYS9v3orQnPIhOtJS5AsXBkK-ZC8NAasUdyx95LBZmK9o7","urls":{"public_profile":"https://www.linkedin.com/in/kidbombay"}},"credentials":{"token":"AQVARc5fzBsJzGNGX0GHGTEP8uQrVUUAyMlwib6PhO7rm5pWG3QkWjmUT2H6dLvDrQ7lsD1ChsSNIi5snVp4LDnAyefjOHYg6GKfpnKwimFCEopAwqyQqZk0dJN06JkJ_CrHwh0VEj0c98s8mwHpCNq8LY88w4F1nRjTDCmtAPv9tLwav28","expires_at":1492441756,"expires":true},"extra":{"raw_info":{"emailAddress":"fire@kidbombay.com","firstName":"Ketan","headline":"CTO at Up All Night SF","id":"Fs7-zkSDyL","industry":"Internet","lastName":"Anjaria","location":{"country":{"code":"us"},"name":"San Francisco Bay Area"},"pictureUrl":"https://media.licdn.com/mpr/mprx/0_x6Xd1PH12k5_nYR3n6tFUXq-eKEYzxw3VGObv62-D8d0K7VgpGtW493-7n6Snfs3n6tWZPCt53Ix1U5g9v3zRb_Yh3IO1UYS9v3orQnPIhOtJS5AsXBkK-ZC8NAasUdyx95LBZmK9o7","publicProfileUrl":"https://www.linkedin.com/in/kidbombay"}}}'
  #     omniauth = JSON.parse(json)

  #     user = User.from_omniauth(omniauth)

  #     expect(user).to be_valid
  #     expect(user).to be_persisted
  #     expect(user.linkedin_url).to eq "https://www.linkedin.com/in/kidbombay"

  #     expect(user.email).to eq("fire@kidbombay.com")
  #     expect(user.name).to eq("Ketan Anjaria")

  #     auth = user.authentications.first
  #     expect(auth).to be_present
  #     expect(auth).to be_valid
  #     expect(auth).to be_persisted
  #   end
  # end

  describe "onboarded?" do
    it "should return false if no username" do
      location = FactoryGirl.create(:location)
      user.location = location
      expect(user.onboarded?).to eq(false)
    end

    it "should return false if no location" do
      user.username = "test"
      expect(user.onboarded?).to eq(false)
    end

    it "should return true if username and location" do
      location = FactoryGirl.create(:location)
      user.location = location
      user.username = "test"
      expect(user.onboarded?).to eq(true)
    end
  end

  describe "available_skills" do
    before {
      user.save
      Skill.seed
    }
    let(:user_skill) { FactoryGirl.create(:user_skill, user: user, skill: Skill.first) }

    it "should return all skills as available when none" do
      expect(user.available_skills.count).to eq Skill.count
    end

    it "should return unused skills when user skill added" do
      user_skill
      expect(user.skills.count).to eq(1)
      expect(user.available_skills.count).to eq Skill.count - 1
    end
  end

  describe "available_roles" do
    before {
      user.save
      Role.seed
    }
    let(:user_role) { FactoryGirl.create(:user_role, user: user, role: Role.first) }

    it "should return all roles as available when none" do
      expect(user.available_roles.count).to eq Role.count
    end

    it "should return unused roles when user role added" do
      user_role
      expect(user.roles.count).to eq(1)
      expect(user.available_roles.count).to eq Role.count - 1
    end
  end

  describe "search" do
    it "should search_by_name" do
      user.name = "Developer"
      user.save

      results = User.search_by_name('dev')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq user      
    end

    it "should search_by_exact_name" do
      user.name = "Developer"
      user.save

      results = User.search_by_exact_name('Developer')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq user      
    end
  end

  describe "activity" do
    it "should have create activity" do
      user.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(user)
      expect(activity.owner).to eq(user)
    end
  end

  describe "key_words" do
    let(:user) { FactoryGirl.create(:user) }

    it "should have roles by position" do
      FactoryGirl.create(:user_role, user: user, position: 0) 
      FactoryGirl.create(:user_role, user: user, position: 10)
      FactoryGirl.create(:user_role, user: user, position: 3)
      user.save 
      # nil added to the end to simulate the addition of further meta tags
      keywords = user.user_roles.by_position.limit(3).map(&:name) + [nil]
      expect(user.key_words).to eq(keywords) 
    end

    it "should have skills by position" do 
      FactoryGirl.create(:user_skill, user: user, position: 10)
      FactoryGirl.create(:user_skill, user: user, position: 11)
      FactoryGirl.create(:user_skill, user: user, position: 12)
      FactoryGirl.create(:user_skill, user: user, position: 13)
      FactoryGirl.create(:user_skill, user: user, position: 14)
      user.save
      # nil added to the end to simulate the addition of further meta tags

      keywords = user.user_skills.by_position.limit(5).map(&:name) + [nil]
      expect(user.key_words).to eq(keywords)
    end 
  end

  describe "website_url" do
    it "should add http if missing" do
      user.website_url = "instagram.com/username"
      expect(user.website_url).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      user.website_url = "www.instagram.com/username"
      expect(user.website_url).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      user.website_url = "foo"
      expect(user.website_url).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username", nil).for(:website_url) }
  end

  describe "instagram_url" do
    it "should add http if missing" do
      user.instagram_url = "instagram.com/username"
      expect(user.instagram_url).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      user.instagram_url = "www.instagram.com/username"
      expect(user.instagram_url).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      user.instagram_url = "foo"
      expect(user.instagram_url).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username", nil).for(:instagram_url) }
  end


  describe "welcome!" do
    it "should create user.welcome activity" do
      user.save
      user.welcome!

      activity = Activity.last

      expect(activity.key).to eq UserWelcomeActivity::KEY
      expect(activity.trackable).to eq user
      expect(activity.owner).to eq user
      expect(activity.private).to eq false
    end

    it "should only welcome once" do
      user.save
      user.welcome!
      user.welcome!
      user.welcome!

      activities = Activity.where(key: UserWelcomeActivity::KEY)

      expect(activities.count).to eq(1)
    end
  end

  describe "suggested username" do
    it "should suggest usernames by name" do
      user.name = "Ketan Anjaria"
      expect(user.suggested_username).to eq "ketananjaria"
    end

    it "should use username if present" do
      user.username = "kidbombay"
      expect(user.suggested_username).to eq "kidbombay"
    end

    it "should suggest usernames by email" do
      email = "ketan@kidbombay.com"
      user.email = email
      user.name = nil
      expect(user.suggested_username).to eq email.split("@")[0]
    end

    it "should append numbers to username" do
      other_user = FactoryGirl.create(:user, username: "ketananjaria")

      user.name = "Ketan Anjaria"
      expect(user.suggested_username).to eq "ketananjaria1"

      other_user2 = FactoryGirl.create(:user, username: "ketananjaria1")
      expect(user.suggested_username).to eq "ketananjaria2"

      other_user3 = FactoryGirl.create(:user, username: "ketananjaria2")
      expect(user.suggested_username).to eq "ketananjaria3"
    end
  end
end

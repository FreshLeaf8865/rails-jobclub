require 'rails_helper'

RSpec.describe Authentication, :type => :model do
  let(:authentication) { FactoryGirl.create(:authentication) }

  subject { authentication }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive }
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_inclusion_of(:provider).in_array(Authentication::VALID_PROVIDERS) }
  end

  describe "from_omniauth" do
    it "should create an auth from facebook omniauth hash" do
      json = '{"provider":"facebook","uid":"10158109415805244","info":{"email":"fire@kidbombay.com","name":"Ketan Anjaria","image":"http://graph.facebook.com/v2.6/10158109415805244/picture?type=large","location":"San Francisco, California"},"credentials":{"token":"EAAROPfhGmSQBAJYKLDRbqpyPVhvm3QvB3FZAvvJgd71nqV5KE7zBMLmZCtlZBwnLUTMfKcN6gceHubTUnWymKrHpON3uYZASErRBTQoRyZAOVOtvRqBtpwEiso9dyZB4sNvxiOrwFfXRHzGLUlppJE9ux4zZCUh2UkZD","expires_at":1491064746,"expires":true},"extra":{"raw_info":{"id":"10158109415805244","name":"Ketan Anjaria","gender":"male","locale":"en_US","email":"fire@kidbombay.com","location":{"id":"114952118516947","name":"San Francisco, California"}}}}
'
      omniauth = JSON.parse(json)

      user = FactoryGirl.create(:user)

      auth = Authentication.new
      auth.user = user
      auth.from_omniauth(omniauth)

      expect(auth).to be_valid
      expect(auth.user).to eq(user)
      expect(auth.provider).to eq("facebook")
      expect(auth.uid).to eq(omniauth["uid"])
      expect(auth.token).to eq(omniauth['credentials']['token'])
      expect(auth.expires).to eq(false)
      expect(auth.omniauth_json).not_to be_nil
    end

    it "should create an auth from linkedin omniauth" do
      json = '{"provider":"linkedin","uid":"Fs7-zkSDyL","info":{"name":"Ketan Anjaria","email":"fire@kidbombay.com","nickname":"Ketan Anjaria","first_name":"Ketan","last_name":"Anjaria","location":{"country":{"code":"us"},"name":"San Francisco Bay Area"},"description":"CTO at Up All Night SF","image":"https://media.licdn.com/mpr/mprx/0_x6Xd1PH12k5_nYR3n6tFUXq-eKEYzxw3VGObv62-D8d0K7VgpGtW493-7n6Snfs3n6tWZPCt53Ix1U5g9v3zRb_Yh3IO1UYS9v3orQnPIhOtJS5AsXBkK-ZC8NAasUdyx95LBZmK9o7","urls":{"public_profile":"https://www.linkedin.com/in/kidbombay"}},"credentials":{"token":"AQVARc5fzBsJzGNGX0GHGTEP8uQrVUUAyMlwib6PhO7rm5pWG3QkWjmUT2H6dLvDrQ7lsD1ChsSNIi5snVp4LDnAyefjOHYg6GKfpnKwimFCEopAwqyQqZk0dJN06JkJ_CrHwh0VEj0c98s8mwHpCNq8LY88w4F1nRjTDCmtAPv9tLwav28","expires_at":1492441756,"expires":true},"extra":{"raw_info":{"emailAddress":"fire@kidbombay.com","firstName":"Ketan","headline":"CTO at Up All Night SF","id":"Fs7-zkSDyL","industry":"Internet","lastName":"Anjaria","location":{"country":{"code":"us"},"name":"San Francisco Bay Area"},"pictureUrl":"https://media.licdn.com/mpr/mprx/0_x6Xd1PH12k5_nYR3n6tFUXq-eKEYzxw3VGObv62-D8d0K7VgpGtW493-7n6Snfs3n6tWZPCt53Ix1U5g9v3zRb_Yh3IO1UYS9v3orQnPIhOtJS5AsXBkK-ZC8NAasUdyx95LBZmK9o7","publicProfileUrl":"https://www.linkedin.com/in/kidbombay"}}}'
      omniauth = JSON.parse(json)

      user = FactoryGirl.create(:user)
      auth = Authentication.new
      auth.user = user
      auth.from_omniauth(omniauth)

      expect(auth).to be_valid
      expect(auth.user).to eq(user)
      expect(auth.provider).to eq("linkedin")
      expect(auth.uid).to eq(omniauth["uid"])
      expect(auth.token).to eq(omniauth['credentials']['token'])
      expect(auth.expires).to eq(false)
      expect(auth.username).to eq("kidbombay")
      expect(auth.omniauth_json).not_to be_nil
    end

    it "should create an auth from google omniauth" do
      json = '{"provider":"google_oauth2","uid":"117870559098729164650","info":{"name":"Ketan Anjaria","email":"ketan@hireclub.co","first_name":"Ketan","last_name":"Anjaria","image":"https://lh6.googleusercontent.com/-PlAu4YWJD9g/AAAAAAAAAAI/AAAAAAAAAAo/lu_q8Cr6Zio/photo.jpg"},"credentials":{"token":"ya29.GlsfBGTyLd8ZZj69NzeAAP54OGgY2H6MK1lA8K78_fqcu5A5LEc2PgkDF6cc5EUo7m15Ixgj_Nl7b1fFawdlY-TeCcd3LCuR6CE2xchJl6GWE9rEFujUf3HvaOoO","refresh_token":"1/r8d6rGKRblZ_Gjg2Ya2JqgYBsHEzaVNPUgkOxHZPnd1RTW3pRjENc5kHk6IEQevY","expires_at":1490978576,"expires":true},"extra":{"id_token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjdjODNmNWNjMTUzNjAwMzczN2MzNzU5YjJiOTBiMWE1ZDFkNGFjNjUifQ.eyJhenAiOiI0NDA3NjY5MjIwNC05ajI1NWVvYWNydTA0ZmlndW9hbmhvOTgzZzFxNHNiNi5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjQ0MDc2NjkyMjA0LTlqMjU1ZW9hY3J1MDRmaWd1b2FuaG85ODNnMXE0c2I2LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTE3ODcwNTU5MDk4NzI5MTY0NjUwIiwiaGQiOiJoaXJlY2x1Yi5jbyIsImVtYWlsIjoia2V0YW5AaGlyZWNsdWIuY28iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IjNnRGZrcXRSd2RPMGtqUk5QaXJnSGciLCJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiaWF0IjoxNDkwOTc0OTc3LCJleHAiOjE0OTA5Nzg1Nzd9.dwayt4BmV9Qkyf9ZCTv3hBxz_tsoE-jb7e1QS7_TugRCrRUA6qVGu5GMFO8z_lK0Bqi8jWwUzsz-a9o11mhPTawaAInVyQhgs6b2iIgGGjiT1OYjrVRpCtB3GJEqAGPhtytskyms0oTKyVfwots_KUXIpfAiJOCtK8EWERp8GQqYooEBZq7g7P0Q4TPQL3-A75zJiIVqNv62MgZaDyr8d9hP2tAMWctq5579XxayP2xjBsVDeElgFnoAt-OTHUlOXMqoS2ba3K1n_JdfA1p2jIGaAOfY2inqa4qUTJl6Vqdjh7IeJ7AwfmHPolBJwfp7qynNqRW4SG6UGzsLVXb8xQ","id_info":{"azp":"44076692204-9j255eoacru04figuoanho983g1q4sb6.apps.googleusercontent.com","aud":"44076692204-9j255eoacru04figuoanho983g1q4sb6.apps.googleusercontent.com","sub":"117870559098729164650","hd":"hireclub.co","email":"ketan@hireclub.co","email_verified":true,"at_hash":"3gDfkqtRwdO0kjRNPirgHg","iss":"accounts.google.com","iat":1490974977,"exp":1490978577},"raw_info":{"kind":"plus#personOpenIdConnect","sub":"117870559098729164650","name":"Ketan Anjaria","given_name":"Ketan","family_name":"Anjaria","picture":"https://lh6.googleusercontent.com/-PlAu4YWJD9g/AAAAAAAAAAI/AAAAAAAAAAo/lu_q8Cr6Zio/photo.jpg?sz=50","email":"ketan@hireclub.co","email_verified":"true","locale":"en","hd":"hireclub.co"}}}'
      omniauth = JSON.parse(json)

      user = FactoryGirl.create(:user)
      auth = Authentication.new
      auth.user = user
      auth.from_omniauth(omniauth)

      expect(auth).to be_valid
      expect(auth.user).to eq(user)
      expect(auth.provider).to eq("google_oauth2")
      expect(auth.uid).to eq(omniauth["uid"])
      expect(auth.token).to eq(omniauth['credentials']['token'])
      expect(auth.expires).to eq(false)
      expect(auth.omniauth_json).not_to be_nil
    end
  end
  
end

require 'rails_helper'

RSpec.describe FacebookService do
  let(:user)  { FactoryGirl.create(:user, username: 'kidbombay') }
  let(:kidbombay_auth) { FactoryGirl.create(:authentication, :kidbombay, user: user) }

  it "should create a facebook client" do
    expect(kidbombay_auth).to be_valid
    expect(user.has_facebook?).to eq(true)

    client = FacebookService.get_client
    expect(client).to be_present
  end

  it "should search facebook pages" do
    expect(kidbombay_auth).to be_valid

    results = FacebookService.search_pages("HireClub")
    expect(results).to be_present

    first = results.first
    expect(first["name"]).to eq "HireClub"
    expect(first["id"]).to eq "1412288385651374"
    expect(first["link"]).to eq "https://www.facebook.com/hireclub/"
  end



end

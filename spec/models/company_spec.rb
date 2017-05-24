require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { FactoryGirl.create(:company) }

  subject { company }

  describe "associations" do
    it { should respond_to(:avatar) }
    it { should respond_to(:logo) }
    it { should have_many(:milestones) }
    it { should have_many(:projects) }
    it { should have_many(:jobs) }
    it { should belong_to(:added_by) }
    it { should have_many(:users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it { should validate_uniqueness_of(:slug).case_insensitive }
    it { should validate_uniqueness_of(:facebook_id) }

    it { is_expected.to allow_value("http://kidbombay.com", "https://kidbombay.com").for(:website_url) }
    # it { is_expected.not_to allow_value("kidbombay.com", "foo").for(:website_url) }
  end

  describe 'seed' do
    # it "should seed companys" do
    #   Company.seed

    #   expect(Company.all.count).to be >= 5
    # end
  end

  describe 'tags' do 
    it "should let you add tags" do
      company.tags_list = "foo, bar"
      company.save

      expect(company).to be_valid
      expect(company.tags[0]).to eq "foo"
      expect(company.tags[1]).to eq "bar"      
    end 
  end

  describe "domain" do
    it "should get domain from website_url" do
      company.website_url = "https://hireclub.co"
      expect(company.domain).to eq("hireclub.co")
    end
  end

  # describe "imports" do
  #   let(:user)  { FactoryGirl.create(:user, username: 'kidbombay') }
  #   let(:kidbombay_auth) { FactoryGirl.create(:authentication, :kidbombay, user: user) }

  #   it "should import company from facebook_id" do
  #     expect(kidbombay_auth).to be_valid
  
  #     id = "32359482111"

  #     company = Company.import_facebook_id(id)
  #     expect(company).to be_present
  #     expect(company).to be_valid
  #     expect(company.name).to eq "The Evergreen State College"
  #     expect(company.slug).to eq "TheEvergreenStateCollege"
  #     expect(company.facebook_id).to eq "32359482111"
  #     # expect(company.website_url).to eq "http://www.evergreen.edu/"
  #     expect(company.facebook_url).to eq "https://www.facebook.com/TheEvergreenStateCollege/"
  #     expect(company.tagline).to be_present
  #     expect(company.avatar).to be_present
  #   end

  #   it "should import company from facebook_id" do
  #     expect(kidbombay_auth).to be_valid
  
  #     id = "821365304544508"

  #     company = Company.import_facebook_id(id)
  #     expect(company).to be_present
  #     expect(company).to be_valid
  #     expect(company.name).to eq "Up All Night SF"
  #     expect(company.slug).to eq "upallnightsf"
  #     expect(company.facebook_id).to eq "821365304544508"
  #     expect(company.facebook_url).to eq "https://www.facebook.com/upallnightsf/"
  #     expect(company.tagline).to be_present
  #     expect(company.avatar).to be_present
  #   end

  #   it "should import company from facebook_id" do
  #     expect(kidbombay_auth).to be_valid
  
  #     id = "294554919629"

  #     company = Company.import_facebook_id(id)
  #     expect(company).to be_present
  #     expect(company).to be_valid
  #     expect(company.name).to eq "kidBombay"
  #     expect(company.slug).to eq "kidbombay"
  #     expect(company.facebook_id).to eq "294554919629"
  #     expect(company.facebook_url).to eq "https://www.facebook.com/kidBombay-294554919629/"
  #     expect(company.tagline).to be_present
  #     expect(company.avatar).to be_present
  #   end

    
  #   it "should import company from facebook_url" do
  #     expect(kidbombay_auth).to be_valid
  
  #     url = "https://www.facebook.com/HappyCoInc/"

  #     company = Company.import_facebook_url(url)

  #     expect(company).to be_present
  #     expect(company).to be_valid
  #     expect(company.name).to eq "HappyCo"
  #     expect(company.slug).to eq "HappyCoInc"
  #     expect(company.facebook_id).to eq "1408344736131335"
  #     expect(company.website_url).to eq "http://www.happyco.com"
  #     expect(company.facebook_url).to eq "https://www.facebook.com/HappyCoInc/"
  #     expect(company.tagline).to be_present
  #     expect(company.avatar).to be_present

  #     url = "https://www.facebook.com/OpenTable/"

  #     company = Company.import_facebook_url(url)

  #     expect(company).to be_present
  #     expect(company).to be_valid
  #     expect(company.name).to eq "OpenTable"
  #     expect(company.slug).to eq "OpenTable"
  #     expect(company.facebook_id).to eq "47650308975"
  #     expect(company.website_url).to eq "http://www.opentable.com"
  #     expect(company.facebook_url).to eq "https://www.facebook.com/OpenTable/"
  #     expect(company.tagline).to be_present
  #     expect(company.avatar).to be_present
  #   end


  #   it "should import companies from companies.json" do
  #     Company.destroy_all

  #     json = Company.import
  #     expect(json).to be_present

  #     companies = Company.all
  #     expect(companies.count).to be > 0

  #     hireclub = companies.first

  #     expect(hireclub).to be_present
  #     expect(hireclub).to be_persisted
  #     expect(hireclub.name).to eq "HireClub"
  #     expect(hireclub.slug).to eq "hireclub"
  #     expect(hireclub.twitter_url).to eq "https://twitter.com/hireclub"
  #     expect(hireclub.website_url).to eq "http://hireclub.co"
  #     expect(hireclub.facebook_url).to eq "https://facebook.com/hireclub"
  #     expect(hireclub.tagline).to eq "Invite only job referrals."      
  #   end
  # end

  describe "search" do
    it "should search_by_name" do
      company.name = "HireClub"
      company.save

      results = Company.search_by_name('hire')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq company    
    end

    it "should search_by_exact_name" do
      company.name = "HireClub"
      company.save

      results = Company.search_by_exact_name('HireClub')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq company      
    end
  end

  describe "website_url" do
    it "should add http if missing" do
      company.website_url = "instagram.com/username"
      expect(company.website_url).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      company.website_url = "www.instagram.com/username"
      expect(company.website_url).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      company.website_url = "foo"
      expect(company.website_url).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:website_url) }
  end

end

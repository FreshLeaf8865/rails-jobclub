require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:location) { FactoryGirl.create(:location) }

  subject { location }

  describe "associations" do
    it { should belong_to(:parent) }
    it { should have_many(:children) }
    it { should have_many(:users) }
    it { should have_many(:jobs) }
    # it { should have_many(:users).through(:user_locations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:parent_id).case_insensitive}

    it { should validate_inclusion_of(:level).in_array(Location::VALID_LEVELS) }

    it { should validate_uniqueness_of(:facebook_id) }  
  end

  describe "slugs" do
    it "should create slug based on name and state code" do
      california = FactoryGirl.create(:location, name: 'California', level: Location::STATE, short: 'CA')
      location.parent = california
      location.name = "San Francisco"
      location.save

      expect(location.slug).to eq "san-francisco-ca"
    end
  end

  describe "root" do
    it "should have a root" do
      root = Location.create_root
      expect(root.name).to eq "Anywhere"
      expect(root.level).to eq Location::ROOT
    end
  end

  describe "imports" do
    it "should import countries" do
      Location.import_countries

      countries = Location.where(level: Location::COUNTRY)
      expect(countries.count).to be > 1

      usa = Location.where(short:'US', level: Location::COUNTRY).first
      expect(usa).to be_present
    end

    it "should import states" do
      Location.import_states

      states = Location.where(level: Location::STATE)
      expect(states.count).to be > 1

      california = Location.where(name:'California', level: Location::STATE).first
      expect(california.short).to eq "CA"
      expect(california.parent).to eq Location.where(short:'US', level: Location::COUNTRY).first

    end

    it "should import cities" do

      Location.import_cities

      la = Location.where(name:'Los Angeles').first
      expect(la).to be_present
      expect(la.parent.name).to eq "California"

      sf = Location.where(name:'San Francisco').first
      expect(sf).to be_present
      expect(sf.parent.name).to eq "California"
    end
  end

  describe "search" do
    it "should search_by_name" do
      location.name = "Developer"
      location.save

      results = Location.search_by_name('dev')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq location      
    end

    it "should search_by_exact_name" do
      location.name = "Developer"
      location.save

      results = Location.search_by_exact_name('Developer')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq location      
    end
  end

  describe "users_count" do
    let(:user) { FactoryGirl.create(:user) }

    it "should cache users count" do
      user.location = location
      user.save

      location.reload
      expect(location.users_count).to eq 1
    end
  end

  describe "name_and_parent for meta-tags" do 
    let(:user) { FactoryGirl.create(:user) }

    it "should have city and state" do
      Location.import_cities
      user.location = Location.where(level: Location::CITY).last
      user.save
      expect(user.key_words).to eq([user.location.name_and_parent])
    end

    it "should return location name and parent" do 
      Location.import_cities
      user.location = Location.where(level: Location::CITY).last
      user.save
      expect(user.location.name_and_parent).to eq("Berkeley, California")
    end 
    
    it "should return name and parent for location meta-tag" do
      expect(location.name_and_parent).to eq("#{location.name}#{location.parent}")
    end

    it "should still return name if parent is nil for location meta-tag" do
      location.parent = nil 
      expect(location.name_and_parent).to eq("#{location.name}")
    end

  end 

  # describe "facebook import" do
  #   let(:user)  { FactoryGirl.create(:user, username: 'kidbombay') }
  #   let!(:kidbombay_auth) { FactoryGirl.create(:authentication, :kidbombay, user: user) }

    # before do
    #   Location.import_cities
    # end

    # it "should import san francisco from facebook" do
    #   expect(kidbombay_auth).to be_valid

    #   facebook_location_id = "114952118516947"

    #   location = Location.import_facebook_id(facebook_location_id)

    #   expect(location).to be_persisted
    #   expect(location.name).to eq "San Francisco"
    #   expect(location.level).to eq Location::CITY
    #   expect(location.short).to be_nil
    #   expect(location.parent).to be_present
    # end

    # it "should import Sri Lanka from facebook" do
    #   expect(kidbombay_auth).to be_valid

    #   facebook_location_id = "108602292505393"

    #   location = Location.import_facebook_id(facebook_location_id)

    #   expect(location).to be_persisted
    #   expect(location.name).to eq "Colombo"
    #   expect(location.slug).to eq "colombo-lk"
    #   expect(location.level).to eq Location::CITY
    #   expect(location.short).to be_nil
    #   expect(location.parent).to be_present
    # end
    
    # it "should import Bakersfield from facebook" do
    #   expect(kidbombay_auth).to be_valid

    #   facebook_location_id = "106152016081829"

    #   location = Location.import_facebook_id(facebook_location_id)

    #   expect(location).to be_persisted
    #   expect(location.name).to eq "Bakersfield"
    #   expect(location.slug).to eq "bakersfield-ca"
    #   expect(location.level).to eq Location::CITY
    #   expect(location.short).to be_nil
    #   expect(location.parent).to be_present
    # end

    # it "should import Melbourne from facebook" do
    #   expect(kidbombay_auth).to be_valid

    #   facebook_location_id = "116190411724975"

    #   location = Location.import_facebook_id(facebook_location_id)

    #   expect(location).to be_persisted
    #   expect(location.name).to eq "Melbourne"
    #   expect(location.slug).to eq "melbourne-au"
    #   expect(location.level).to eq Location::CITY
    #   expect(location.short).to be_nil
    #   expect(location.parent).to be_present
    # end
  # end

end

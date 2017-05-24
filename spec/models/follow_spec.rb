require 'rails_helper'

RSpec.describe Follow, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:company) { FactoryGirl.create(:company) }
  
  before do
    user.follow(company)
  end

  subject { follow }

  describe "follow company" do
    it "should have company.follow activity once" do
      user.follow(company)
      user.follow(company)
      
      activities = PublicActivity::Activity.where(key: CompanyFollowActivity::KEY)
      expect(activities.count).to eq 1

      activity = activities.first

      expect(activity).to be_present
      expect(activity.owner).to eq(user)
      expect(activity.trackable).to eq(company)
    end

    it "should have company.unfollow activity" do
      user.follow(company)
      user.stop_following(company)
      user.follow(company)
      user.stop_following(company)
      
      
      activities = PublicActivity::Activity.where(key: CompanyUnfollowActivity::KEY)
      expect(activities.count).to eq 2

      activity = activities.first

      expect(activity).to be_present
      expect(activity.owner).to eq(user)
      expect(activity.trackable).to eq(company)
      expect(activity.published).to eq(false)
    end
  end

  describe "follow user" do
    let(:user_to_follow) { FactoryGirl.create(:user) }
    it "should have user.follow activity once" do
      user.follow(user_to_follow)
      user.follow(user_to_follow)
      
      activities = PublicActivity::Activity.where(key: UserFollowActivity::KEY)
      expect(activities.count).to eq 1

      activity = activities.first

      expect(activity).to be_present
      expect(activity.owner).to eq(user)
      expect(activity.trackable).to eq(user_to_follow)
    end

    it "should have user.unfollow activity" do
      user.follow(user_to_follow)
      user.stop_following(user_to_follow)
      user.follow(user_to_follow)
      user.stop_following(user_to_follow)
      
      
      activities = PublicActivity::Activity.where(key: UserUnfollowActivity::KEY)
      expect(activities.count).to eq 2

      activity = activities.first

      expect(activity).to be_present
      expect(activity.owner).to eq(user)
      expect(activity.trackable).to eq(user_to_follow)
      expect(activity.published).to eq(false)

      activities = PublicActivity::Activity.where(key: UserFollowActivity::KEY)
      expect(activities.count).to eq 1
      activity = activities.first

      expect(activity).to be_present
      expect(activity.owner).to eq(user)
      expect(activity.trackable).to eq(user_to_follow)
      expect(activity.published).to eq(false)
    end
  end
end
require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:like) { FactoryGirl.create(:like) }

  subject { like }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:likeable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:likeable_id) }
    it { should validate_presence_of(:likeable_type) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:likeable_id, :likeable_type]).case_insensitive }
  end

  describe 'counter_cache' do
    it "should cache likes_count on likeable" do
      expect(like.likeable.likes_count).to eq(1)

      like.destroy
    
      expect(like.likeable.likes_count).to eq(0)      
    end
  end

  describe "activity" do
    it "should have create activity" do
      like
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(like)
      expect(activity.owner).to eq(like.user)
    end
  end

  describe "likeable_name" do

    it "should be project name when project" do
      expect(like.likeable_name).to eq like.likeable.name
    end

    it "should be milestone name when milestone" do
      milestone = FactoryGirl.create(:milestone)
      like =  FactoryGirl.create(:like, likeable: milestone)
      expect(like.likeable_name).to eq like.likeable.name
    end

    it "should be badge name when badge" do
      user_badge = FactoryGirl.create(:user_badge)
      like =  FactoryGirl.create(:like, likeable: user_badge)
      expect(like.likeable_name).to eq like.likeable.name
    end
  end
end

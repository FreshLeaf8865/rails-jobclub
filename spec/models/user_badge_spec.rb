require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  let(:user_badge) { FactoryGirl.build(:user_badge) }

  subject { user_badge }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:badge) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:badge) }
    it { should validate_uniqueness_of(:badge_id).scoped_to(:user_id) }
  end

  describe "broadcasts" do
    it "broadcasts update_user_badge on save" do
      expect { user_badge.save }.to broadcast(:update_user_badge, user_badge)
    end

    it "broadcasts update_user_badge on destroy" do
      expect { user_badge.destroy }.to broadcast(:update_user_badge, user_badge)
    end
  end

  describe "activity" do
    it "should have create activity" do
      user_badge.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(user_badge)
      expect(activity.owner).to eq(user_badge.user)
    end
  end
end

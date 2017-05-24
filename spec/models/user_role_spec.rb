require 'rails_helper'

RSpec.describe UserRole, type: :model do
  let(:user_role) { FactoryGirl.build(:user_role) }

  subject { user_role }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:role) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:role) }

    it { should validate_uniqueness_of(:role_id).scoped_to(:user_id) }
  end

  describe "activity" do
    it "should have create activity" do
      user_role.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(user_role)
      expect(activity.owner).to eq(user_role.user)
    end

    it "should unpublish activity on destroy" do
      user_role.save
      user_role.destroy
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to be_nil
      expect(activity.published).to eq(false)
    end
  end
end

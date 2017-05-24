require 'rails_helper'

RSpec.describe ReviewRequest, type: :model do
  let(:review_request) { FactoryGirl.build(:review_request) }

  subject { review_request }

  describe "associations" do
    it { should belong_to(:user)}
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:commenters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_length_of(:goal).is_at_least(10) }
  end
  
  describe 'activity' do
    it "should create activity" do
      reviewer = FactoryGirl.create(:user, is_reviewer: true)
      review_request.save

      activity = Activity.last
      expect(activity.key).to eq ReviewRequestCreateActivity::KEY
      expect(activity.trackable).to eq review_request
      expect(activity.owner).to eq review_request.user
    end
  end
end

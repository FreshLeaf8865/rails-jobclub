require 'rails_helper'

RSpec.describe Mention, type: :model do
  let(:mention) { FactoryGirl.create(:mention) }

  subject { mention }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:sender) }
    it { should belong_to(:mentionable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:sender_id) }
    it { should validate_presence_of(:mentionable_id) }
    it { should validate_presence_of(:mentionable_type) }
    it { should validate_uniqueness_of(:user_id).scoped_to([:mentionable_id, :mentionable_type]).case_insensitive }
  end

  # describe 'counter_cache' do
  #   it "should cache mentions_count on mentionable" do
  #     expect(mention.mentionable.mentions_count).to eq(1)

  #     mention.destroy
    
  #     expect(mention.mentionable.mentions_count).to eq(0)      
  #   end
  # end

  describe "activity" do
    it "should have create activity" do
      mention
      activity = mention.activities.first
      expect(activity).to be_present
      expect(activity.trackable).to eq(mention)
      expect(activity.owner).to eq(mention.sender)
      expect(activity.recipient).to eq(mention.user)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(1)
      notification = notifications.first
      expect(notification.user).to eq mention.user
    end
  end

end

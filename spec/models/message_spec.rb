require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:message) { FactoryGirl.build(:message, user: user) }

  subject { message }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
  end

  describe 'validations' do
    it { should validate_presence_of(:conversation) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:text) }
  end

  describe "activity" do
    let(:user2) { FactoryGirl.create(:user) }

    it "should have create activity" do
      conversation = Conversation.between([user, user2])
      message = FactoryGirl.create(:message, user: user, conversation: conversation)

      activity = PublicActivity::Activity.where(key: MessageCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(message)
      expect(activity.owner).to eq(message.user)
      expect(activity.private).to eq(true)

      recipients = MessageCreateActivity.get_recipients_for(activity)
      expect(recipients.count).to be > 0
      expect(recipients.count).to eq(message.conversation.users.count - 1)

      #expect(user2.unread_messages_count).to eq(1)
    end

    it "should have message.read activity" do
      conversation = Conversation.between([user, user2])
      message = FactoryGirl.create(:message, user: user, conversation: conversation)

      message.read_by!(user2)
      message.read_by!(user2) #create only one activity

      activities = PublicActivity::Activity.where(key: MessageReadActivity::KEY)
      expect(activities.count).to eq(1)

      activity = activities.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(message)
      expect(activity.owner).to eq(user2)
      expect(activity.private).to eq(true)
      expect(activity.published).to eq(false)
      expect(activity.recipient).to eq(message.conversation)
    end

  end

end

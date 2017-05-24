require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryGirl.build(:comment) }

  subject { comment }

  describe "associations" do
    it { should belong_to(:user)}
    it { should belong_to(:commentable)}
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:commentable) }
    it { should validate_presence_of(:text) }
  end

  describe "activity" do
    it "should have create activity" do
      comment.save
      activity = Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(comment)
      expect(activity.owner).to eq(comment.user)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(1)
      notification = notifications.first
      expect(notification.user).to eq comment.commentable.user
    end
  end

  describe "mentions" do
    let(:kidbombay) {FactoryGirl.create(:user, username: "kidbombay")}
    let(:other_user) {FactoryGirl.create(:user, username: "test.user3")}
    
    it "should let you mention users by username" do
      comment.text = "hey @#{kidbombay.username} you should meet @#{other_user.username}"

      expect(comment.mentioned_users.size).to eq(2)
      expect(comment.mentioned_users[0]).to eq(kidbombay)
      expect(comment.mentioned_users[1]).to eq(other_user)
    end

    it "should create mentions on save" do
      comment.text = "hey @#{kidbombay.username} you should meet @#{other_user.username}"
      comment.save

      expect(comment.mentions.size).to eq(2)
      mention = comment.mentions.first
      expect(mention.user).to eq(kidbombay)
      expect(mention.sender).to eq(comment.user)
      expect(mention.mentionable).to eq(comment)
    end
  end
end

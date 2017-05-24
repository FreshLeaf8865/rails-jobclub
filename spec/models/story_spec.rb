require 'rails_helper'

RSpec.describe Story, type: :model do
  let(:story) { FactoryGirl.build(:story) }

  subject { story }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:commenters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }
  end


  describe "activity" do

    it "should have create activity" do
      story.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(story)
      expect(activity.owner).to eq(story.user)
      expect(activity.private).to eq(true)
    end
  end

  describe 'publish!' do
    it "publishes the story" do
      other_user = FactoryGirl.create(:user)
      other_user.follow(story.user)

      story.save
      story.publish!

      expect(story.published?).to eq(true)
      expect(story.published_on).not_to be_nil

      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.key).to eq StoryPublishActivity::KEY
      expect(activity.trackable).to eq(story)
      expect(activity.owner).to eq(story.user)
      expect(activity.private).to eq(false)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(1)
      
      notification = notifications.first
      expect(notification.user).to eq other_user
    end
  end

  describe 'tags' do 
    it "should let you add tags" do
      story.tags_list = "foo, bar"
      story.save

      expect(story).to be_valid
      expect(story.tags[0]).to eq "foo"
      expect(story.tags[1]).to eq "bar"      
    end 
  end

end

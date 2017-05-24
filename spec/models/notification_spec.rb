require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { FactoryGirl.build(:notification) }

  subject { notification }

  before do
    Notification.enabled = true
    allow(Notification).to receive(:delay).and_return(Notification)
  end

  describe "associations" do
    it { should belong_to(:user) }
    
    it { should belong_to(:activity) }
  end

  describe 'validations' do
    it { should validate_presence_of(:activity) }
    it { should validate_presence_of(:user) }
    it { should validate_uniqueness_of(:activity_id).scoped_to(:user_id) }
  end

  context 'mark_as_read' do
    it "should mark scope as read" do
      user = FactoryGirl.build(:user)
      3.times do
        FactoryGirl.create(:notification, user: user)
      end

      notifications = user.notifications.published.recent

      Notification.mark_as_read(notifications)

      notifications.each do |notification|
        expect(notification.read?).to be true
      end
    end
  end

  context 'like.create' do
    let(:like) { FactoryGirl.create(:like) }
    it "should create notification for likeable user" do
      expect(like).to be_valid
      Notification.create_notifications_for_activity(like.activities.last.id)

      notification = Notification.last

      expect(notification).to be_present
      expect(notification.activity_key).to eq LikeCreateActivity::KEY
      expect(notification.user).to eq (like.likeable.user)

      activity = notification.activity
      expect(activity.owner).to eq(like.user)
    end
  end

  context 'badge.create' do
    let(:user_badge) { FactoryGirl.create(:user_badge) }
    it "should badge notification for likeable user" do
      expect(user_badge).to be_valid
      Notification.create_notifications_for_activity(user_badge.activities.last.id)

      notification = Notification.last

      expect(notification).to be_present
      expect(notification.activity_key).to eq UserBadgeCreateActivity::KEY
      expect(notification.user).to eq (user_badge.user)

      activity = notification.activity
      expect(activity.owner).to eq(user_badge.user)
    end
  end

  context 'user.welcome' do
    let(:user) { FactoryGirl.create(:user) }
    it "should create user.welcome notification" do
      expect(user).to be_valid
      user.welcome!

      activity = user.activities.where(key: UserWelcomeActivity::KEY).first

      Notification.create_notifications_for_activity(activity.id)

      notification = Notification.last

      expect(notification).to be_present
      expect(notification.activity_key).to eq UserWelcomeActivity::KEY
      expect(notification.user).to eq (user)

      activity = notification.activity
      expect(activity.owner).to eq(user)
    end
  end

end

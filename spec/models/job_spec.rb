require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:job) { FactoryGirl.build(:job) }
  let(:skill) { FactoryGirl.create(:skill) }
  let(:skill2) { FactoryGirl.create(:skill) }

  subject { job }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:company) }
    it { should belong_to(:role) }
    it { should belong_to(:location) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(6).is_at_most(50) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:company) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:description) }
    
    #it { should validate_uniqueness_of(:slug).case_insensitive }
    
    it "should be valid only with approved skills" do
      job.skills = [skill.name, skill2.name]
      job.save

      expect(job).to be_valid

      job.skills = ["foo"]
      expect(job).not_to be_valid

      job.skills_list = "bar, dog"
      expect(job).not_to be_valid
    end
  end

  describe "link" do
    it "should add http if missing" do
      job.link = "instagram.com/username"
      expect(job.link).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      job.link = "www.instagram.com/username"
      expect(job.link).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      job.link = "foo"
      expect(job.link).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:link) }
  end

  describe "activity" do
    it "should have create activity" do
      job.save

      activity = PublicActivity::Activity.where(key: JobCreateActivity::KEY).last
      expect(activity).to be_present
      expect(activity.trackable).to eq(job)
      expect(activity.owner).to eq(job.user)
      expect(activity.private).to eq(true)
    end
  end

  describe 'publish!' do
    it "publishes the story" do
      company_follower = FactoryGirl.create(:user)
      company_follower.follow(job.company)
      company_follower.follow(job.user)

      user_follower = FactoryGirl.create(:user)
      user_follower.follow(job.user)

      job.save
      job.publish!

      expect(job.published?).to eq(true)
      expect(job.published_on).not_to be_nil

      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.key).to eq JobPublishActivity::KEY
      expect(activity.trackable).to eq(job)
      expect(activity.owner).to eq(job.user)
      expect(activity.private).to eq(false)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(2)
      
      notification = notifications.first
      expect(notification.user).to eq company_follower
    end
  end


  describe "skills" do
    it "should be able to set skills as array" do
      job.skills = [skill.name, skill2.name]
      job.save

      expect(job.skills.count).to eq 2
      expect(job.skills).to include(skill.name)
      expect(job.skills).to include(skill2.name)

      jobs = Job.with_any_skills(skill.name)
      expect(jobs.count).to eq(1)
    end

    it "should be able to set skills as string" do
      job.skills_list = "  #{skill.name},    #{skill2.name}  "
      job.save

      expect(job.skills.count).to eq 2
      expect(job.skills).to include(skill.name)
      expect(job.skills).to include(skill2.name)
      expect(job.skills_list).to eq "#{skill.name}, #{skill2.name}"
    end
  end



end

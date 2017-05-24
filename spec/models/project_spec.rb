require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryGirl.build(:project) }
  let(:skill) { FactoryGirl.create(:skill) }
  let(:skill2) { FactoryGirl.create(:skill) }
  let(:company) { FactoryGirl.create(:company)}

  subject { project }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:company) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:position) }
    it { should validate_presence_of(:image) }
    #it { should validate_uniqueness_of(:slug).case_insensitive }

    it "should be valid only with approved skills" do
      project.skills = [skill.name, skill2.name]
      project.save

      expect(project).to be_valid

      project.skills = ["foo"]
      expect(project).not_to be_valid

      project.skills_list = "bar, dog"
      expect(project).not_to be_valid
    end
  end

  describe "broadcasts" do
    it "broadcasts update_project on save" do
      expect { project.save }.to broadcast(:update_project, project)
    end

    it "broadcasts update_project on destroy" do
      expect { project.destroy }.to broadcast(:update_project, project)
    end
  end

  describe "next/previous project" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:project1) { FactoryGirl.create(:project, user: user, position: 0) }
    let!(:project2) { FactoryGirl.create(:project, user: user, position: 1) }
    let!(:project3) { FactoryGirl.create(:project, user: user, position: 2) }

    it "should link to next project for user" do
      expect(project1.next_project).to eq(project2)
      expect(project2.next_project).to eq(project3)
      expect(project3.next_project).to eq(nil)
    end

    it "should link to previous project for user" do
      expect(project1.previous_project).to eq(nil)
      expect(project2.previous_project).to eq(project1)
      expect(project3.previous_project).to eq(project2)
    end
  end

  describe "skills" do
    it "should be able to set skills as array" do
      project.skills = [skill.name, skill2.name]
      project.save

      expect(project.skills.count).to eq 2
      expect(project.skills).to include(skill.name)
      expect(project.skills).to include(skill2.name)

      projects = Project.with_any_skills(skill.name)
      expect(projects.count).to eq(1)
    end

    it "should be able to set skills as string" do
      project.skills_list = "  #{skill.name},    #{skill2.name}  "
      project.save

      expect(project.skills.count).to eq 2
      expect(project.skills).to include(skill.name)
      expect(project.skills).to include(skill2.name)
      expect(project.skills_list).to eq "#{skill.name}, #{skill2.name}"
    end
  end


  describe "key_words" do 

    it "should return skills_list with added company as meta tags" do
      company = FactoryGirl.create(:company)
      project.company = company
      project.skills = [skill.name, skill2.name]
      project.save
      expect(project.key_words).to eq(project.skills_list + ", " + company.name)
    end

    it "should return skills when company is nil" do
      project.skills = [skill.name, skill2.name]
      project.save
      expect(project.key_words).to eq(project.skills_list)
    end

    it "should return company name when skills are nil" do
      company = FactoryGirl.create(:company)
      project.company = company
      project.save
      expect(project.key_words).to eq(company.name)
    end

  end

  describe "activity" do
    it "should have create activity" do
      other_user = FactoryGirl.create(:user)
      other_user.follow(project.user)

      project.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(project)
      expect(activity.owner).to eq(project.user)

      CreateNotificationJob.perform_now(activity.id)

      notifications = Notification.where(activity: activity)
      expect(notifications.count).to eq(1)
      
      notification = notifications.first
      expect(notification.user).to eq other_user
    end
  end

  describe "badges" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      Badge.seed
    end

    it "should reward project badge after 3 milestones" do
      3.times do 
        FactoryGirl.create(:project, user: user)
      end
      expect(user.projects.count).to eq 3

      user_badge = user.user_badges.first
      expect(user_badge).to be_present
      expect(user_badge.name).to eq "ProPro"
    end
  end

  describe "acts_as_likeable" do
    let!(:project) { FactoryGirl.create(:project) }
    let(:user) { FactoryGirl.create(:user) }
    context "no likes" do
      it "should get no likes when not liked" do
        expect(project.likes.any?).to be false
      end

      it "liked? should return false" do
        expect(project.liked?).to be false
      end

      it "like!(user) should create like" do
        liked = project.like!(user)
        expect(liked).to be true
        expect(project.liked_by?(user)).to be true
      end

      it "toggle_like!(user) should create like" do
        liked = project.toggle_like!(user)
        expect(liked).to be true
        expect(project.liked_by?(user)).to be true
      end
    end

    context "likes exists" do
      let!(:like) { FactoryGirl.create(:like, likeable: project) }
      it "should get likes" do
        like
        expect(project.likes.any?).to be true
        expect(project.likes.count).to eq 1
        expect(project.likes.first).to eq like
      end

      it "liked? should return true" do
        expect(project.liked?).to be true
      end

      it "liked_by?(liker) should return true" do
        expect(project.liked_by?(like.user)).to be true
      end

      it "liked_by?(other_user) should return false" do
        expect(project.liked_by?(project.user)).to be false
      end

      it "unlike!(user) should destroy like" do
        liked = project.unlike!(like.user)
        expect(liked).to be false
        expect(project.liked_by?(user)).to be false
        expect(project.likes.count).to eq 0
      end

      it "toggle_like!(user) should destroy like" do
        liked = project.toggle_like!(like.user)
        expect(liked).to be false
        expect(project.liked_by?(user)).to be false
      end
    end
  end
end

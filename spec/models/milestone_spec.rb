require 'rails_helper'

RSpec.describe Milestone, type: :model do
  let(:milestone) { FactoryGirl.build(:milestone) }
  let(:skill) { FactoryGirl.create(:skill) }
  let(:skill2) { FactoryGirl.create(:skill) }

  subject { milestone }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:company) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:commenters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:facebook_id) }
    it "should be valid only with approved skills" do
      milestone.skills = [skill.name, skill2.name]
      milestone.save

      expect(milestone).to be_valid

      milestone.skills = ["foo"]
      expect(milestone).not_to be_valid

      milestone.skills_list = "bar, dog"
      expect(milestone).not_to be_valid
    end
  end


  describe "activity" do
    it "should have create activity" do
      milestone.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(milestone)
      expect(activity.owner).to eq(milestone.user)
    end
  end

  describe "broadcasts" do
    it "broadcasts update_milestone on save" do
      expect { milestone.save }.to broadcast(:update_milestone, milestone)
    end

    it "broadcasts update_milestone on destroy" do
      expect { milestone.destroy }.to broadcast(:update_milestone, milestone)
    end
  end

  describe "badges" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      Badge.seed
    end

    it "should reward milestone badge after 5 milestones" do
      5.times do 
        FactoryGirl.create(:milestone, user: user)
      end
      expect(user.milestones.count).to eq 5

      user_badge = user.user_badges.first
      expect(user_badge).to be_present
      expect(user_badge.name).to eq "Milestoned"
    end

    it "should reward milehigh badge after 10 milestones" do
      10.times do 
        FactoryGirl.create(:milestone, user: user)
      end
      expect(user.milestones.count).to eq 10

      user_badge = user.user_badges.last
      expect(user_badge).to be_present
      expect(user_badge.name).to eq "Mile High Club"
    end
  end
  
    describe "link" do
    it "should add http if missing" do
      milestone.link = "instagram.com/username"
      expect(milestone.link).to eq("http://instagram.com/username")
    end

    it "should add http if missing ignoring subdomains" do
      milestone.link = "www.instagram.com/username"
      expect(milestone.link).to eq("http://www.instagram.com/username")
    end

    it "should ignore invalid urls" do
      milestone.link = "foo"
      expect(milestone.link).to eq(nil)
    end

    it { is_expected.to allow_value("foo.com", "foo.co", "foo.design", "foo.design/username").for(:link) }
  end

  describe "skills" do
    it "should be able to set skills as array" do
      milestone.skills = [skill.name, skill2.name]
      milestone.save

      expect(milestone.skills.count).to eq 2
      expect(milestone.skills).to include(skill.name)
      expect(milestone.skills).to include(skill2.name)

      milestones = Milestone.with_any_skills(skill.name)
      expect(milestones.count).to eq(1)
    end

    it "should be able to set skills as string" do
      milestone.skills_list = "  #{skill.name},    #{skill2.name}  "
      milestone.save

      expect(milestone.skills.count).to eq 2
      expect(milestone.skills).to include(skill.name)
      expect(milestone.skills).to include(skill2.name)
      expect(milestone.skills_list).to eq "#{skill.name}, #{skill2.name}"
    end
  end

end

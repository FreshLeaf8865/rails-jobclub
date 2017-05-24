require 'rails_helper'

RSpec.describe UserSkill, type: :model do
  let(:user_skill) { FactoryGirl.build(:user_skill) }

  subject { user_skill }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:skill) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:skill) }
    it { should validate_numericality_of(:years).is_greater_than_or_equal_to(0) }
    it { should validate_uniqueness_of(:skill_id).scoped_to(:user_id) }
  end

  describe "broadcasts" do
    it "broadcasts update_user_skill on save" do
      expect { user_skill.save }.to broadcast(:update_user_skill, user_skill)
    end

    it "broadcasts update_user_skill on destroy" do
      expect { user_skill.destroy }.to broadcast(:update_user_skill, user_skill)
    end
  end

  describe "years experience" do
    it "should update user.years_experience on create" do
      user_skill.years = 1
      user_skill.save

      expect(user_skill.user.years_experience).to eq(1)
    end
  end

  describe "activity" do
    it "should have create activity" do
      user_skill.save
      activity = PublicActivity::Activity.last
      expect(activity).to be_present
      expect(activity.trackable).to eq(user_skill)
      expect(activity.owner).to eq(user_skill.user)
    end
  end

  describe "badges" do
    let(:user) { FactoryGirl.create(:user) }
    it "should reward skill badge after 5 skills" do
      Badge.seed
      5.times do 
        FactoryGirl.create(:user_skill, user: user)
      end
      expect(user.skills.count).to eq 5

      user_badge = user.user_badges.first
      expect(user_badge).to be_present
    end
  end

  describe "name_years" do
    before(:all) do
      Skill.seed
    end
    
    it "should get name : years" do
      expect(user_skill.name_years).to eq "#{user_skill.name} : #{user_skill.years}"
    end

    it "should set name : years" do
      user_skill.name_years = "Design : 4"
      user_skill.save

      expect(user_skill.name).to eq "Design"
      expect(user_skill.years).to eq 4
    end

    it "should accept name only" do
      new_skill = Skill.last
      original_years = user_skill.years
      user_skill.name_years = "#{new_skill.name}"
      user_skill.save

      expect(user_skill.skill).to eq new_skill
      expect(user_skill.years).to eq original_years
    end

    it "should ignore invalid name only" do
      original_skill = user_skill.skill
      original_years = user_skill.years
      user_skill.name_years = "SkillWeDontHave"
      user_skill.save

      expect(user_skill.skill).to eq original_skill
      expect(user_skill.years).to eq original_years
    end

    it "should ignore invalid name : years" do
      original_skill = user_skill.skill
      original_years = user_skill.years
      user_skill.name_years = "SkillWeDontHave : 4"
      user_skill.save

      expect(user_skill.skill).to eq original_skill
      expect(user_skill.years).to eq original_years
    end

    it "should ignore name invalid seperator years" do
      original_skill = user_skill.skill
      original_years = user_skill.years
      user_skill.name_years = "SkillWeDontHave ; 4"
      user_skill.save

      expect(user_skill.skill).to eq original_skill
      expect(user_skill.years).to eq original_years
    end

    it "should ignore name : invalid years" do
      original_skill = user_skill.skill
      original_years = user_skill.years
      user_skill.name_years = "#{original_skill.name} : foo"
      user_skill.save

      expect(user_skill.skill).to eq original_skill
      expect(user_skill.years).to eq original_years
    end

    it "should ignore name : negative years" do
      original_skill = user_skill.skill
      original_years = user_skill.years
      user_skill.name_years = "#{original_skill.name} : -1"
      user_skill.save

      expect(user_skill.skill).to eq original_skill
      expect(user_skill.years).to eq original_years
    end


  end
end

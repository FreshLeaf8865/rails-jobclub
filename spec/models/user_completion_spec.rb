require 'rails_helper'

RSpec.describe UserCompletion, :type => :model do
  let(:user) { FactoryGirl.build(:user) }
  let(:user_completion) { UserCompletion.new(user) }
  let(:location) { FactoryGirl.create(:location)}
  let(:username) { "testy" }
  let(:location) { FactoryGirl.build(:location) }

  subject { user_completion }

  describe "associations" do
    it "should set the user" do
      expect(user_completion.user).to eq user
    end
  end

  context "percent_complete" do
    it "should return 10 for new user" do
      expect(user_completion.percent_complete).to eq 0
    end

    it "should return 10 when username set" do
      user.username = username
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when website_url set" do
      user.website_url = "http://hireclub.co"
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when bio set" do
      user.bio = username
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when location set" do
      user.location = location
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when user role set" do
      user_role = FactoryGirl.create(:user_role, user: user)
      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when 5 skills added" do
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end

      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when 3 projects added" do
      3.times do
        FactoryGirl.create(:project, user: user)
      end

      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when 5 milestones added" do
      5.times do
        FactoryGirl.create(:milestone, user: user)
      end

      expect(user_completion.percent_complete).to eq 10
    end

    it "should return 10 when avatar set" do
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user.save
      expect(user_completion.percent_complete).to eq 10
    end
  end

  context "next_step" do
    it "should return Set Username when no username" do
      expect(user_completion.next_step).to eq UserCompletion::USERNAME_STEP
    end

    it "should return Set Location when no location" do
      user.username = username
      expect(user_completion.next_step).to eq UserCompletion::LOCATION_STEP
    end

    it "should return Complete Bio when no bio" do
      user.username = username
      user.location = location
      expect(user_completion.next_step).to eq UserCompletion::BIO_STEP
    end

    it "should return Add avatar when no avatar" do
      user.username = username
      user.location = location
      user.bio = "this is a bio"
      expect(user_completion.next_step).to eq UserCompletion::AVATAR_STEP
    end

    it "should return Add roles when no roles" do
      user.username = username
      user.location = location
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user.save
      expect(user_completion.next_step).to eq UserCompletion::ROLES_STEP
    end

    it "should return Add 5 or more skills when less than 5 skills" do
      user.username = username
      user.location = location
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      expect(user_completion.next_step).to eq UserCompletion::SKILLS_STEP
    end

    it "should return Add 2 or more projects when less than 2 projects" do
      user.username = username
      user.location = location
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      expect(user_completion.next_step).to eq UserCompletion::PROJECTS_STEP
    end

    it "should return Add 5 or more milestones when less than 5 milestones" do
      user.username = username
      user.location = location
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
      3.times do
        FactoryGirl.create(:project, user: user)
      end
      expect(user_completion.next_step).to eq UserCompletion::MILESTONES_STEP
    end

    it "should return Add website_url when no website_url" do
      user.username = username
      user.location = location
      user.bio = "this is a bio"
      user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
      user_role = FactoryGirl.create(:user_role, user: user)
      user.save
      5.times do
        FactoryGirl.create(:user_skill, user: user)
      end
    end 
  end 
end 

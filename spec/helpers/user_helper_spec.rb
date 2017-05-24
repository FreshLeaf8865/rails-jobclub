require 'rails_helper'

describe UserHelper do
  let(:user) { FactoryGirl.build(:user) }
  let(:user_completion) { UserCompletion.new(user) }
  let(:location) { FactoryGirl.create(:location)}
  let(:username) { "testy" }
  let(:next_path) { next_user_completion_path(user_completion) }

  it "should return settings path when no username" do
    expect(next_path).to eq edit_user_registration_path
  end

  it "should return settings path no location" do
    user.username = "test"

    expect(next_path).to eq edit_user_registration_path
  end

  it "should return settings path when no bio" do
    user.username = "test"
    user.location = location

    expect(next_path).to eq edit_user_registration_path
  end

  it "should return settings path when no avatar" do
    user.username = "test"
    user.location = location
    user.bio = "this is a bio"

    expect(next_path).to eq edit_user_registration_path
  end

  it "should return new user role path when no roles" do
    user.username = "test"
    user.location = location
    user.bio = "this is a bio"
    user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
    user.save

    expect(next_path).to eq new_user_role_path
  end

  it "should return new user skill path when less than 5 skills" do
    user.username = "test"
    user.location = location
    user.bio = "this is a bio"
    user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
    user_role = FactoryGirl.create(:user_role, user: user)
    user.save

    expect(next_path).to eq new_user_skill_path
  end

  it "should return new user project path when less than 3 projects" do
    user.username = "test"
    user.location = location
    user.bio = "this is a bio"
    user.avatar = File.new("#{Rails.root}/spec/support/fixtures/image.png")
    user_role = FactoryGirl.create(:user_role, user: user)
    user.save
    5.times do
      FactoryGirl.create(:user_skill, user: user)
    end
  
    expect(next_path).to eq new_project_path
  end

  it "should return new user milestone path when less than 5 milestones" do
    user.username = "test"
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

    expect(next_path).to eq new_milestone_path
  end

  it "should return settings path when no website_url" do
    user.username = "test"
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
    5.times do
      FactoryGirl.create(:milestone, user: user)
    end

    expect(next_path).to eq edit_user_registration_path
  end

  
end

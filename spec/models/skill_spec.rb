require 'rails_helper'

RSpec.describe Skill, type: :model do
  let(:skill) { FactoryGirl.create(:skill) }

  subject { skill }

  describe "associations" do
    it { should have_many(:user_skills) }
    it { should have_many(:users).through(:user_skills) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it { should validate_uniqueness_of(:slug).case_insensitive }
  end

  describe 'seed' do
    it "should seed skills" do
      Skill.seed

      expect(Skill.all.count).to be >= 5
    end
  end

  describe "search" do
    it "should search_by_name" do
      skill.name = "orange"
      skill.save

      results = Skill.search_by_name('oran')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq skill    
    end

    it "should search_by_exact_name" do
      skill.name = "Developer"
      skill.save

      results = Skill.search_by_exact_name('Developer')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq skill      
    end
  end

end
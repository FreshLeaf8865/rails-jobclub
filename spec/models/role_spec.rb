require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:role) { FactoryGirl.create(:role) }

  subject { role }

  describe "associations" do
    it { should have_many(:user_roles) }
    it { should have_many(:users).through(:user_roles) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }

    it { should validate_uniqueness_of(:slug).case_insensitive }
  end

  describe 'seed' do
    it "should seed roles" do
      Role.seed
      expect(Role.all.count).to be >= 1
      
      developer = Role.search_by_exact_name("Developer").first
      expect(developer).to be_persisted
      expect(developer.parent).to be_nil

      front_end = Role.search_by_exact_name("Front End Developer").first
      expect(front_end).to be_persisted
      expect(front_end.parent).to eq developer
    end
  end

  describe "search" do
    it "should search_by_name" do
      role.name = "Developer"
      role.save

      results = Role.search_by_name('dev')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq role      
    end

    it "should search_by_exact_name" do
      role.name = "Developer"
      role.save

      results = Role.search_by_exact_name('Developer')

      expect(results).not_to be_nil
      expect(results.count).to eq 1
      expect(results.first).to eq role      
    end
  end

end
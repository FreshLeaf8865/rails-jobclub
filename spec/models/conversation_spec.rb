require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:conversation) { FactoryGirl.build(:conversation) }
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  
  subject { conversation }

  describe "associations" do
    it { should have_many(:conversation_users).dependent(:destroy) }
    it { should have_many(:users).through(:conversation_users) }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:slug) }
    #it { should validate_uniqueness_of(:key).case_insensitive }
  end

  describe "between" do
    

    it "should create conversation between users" do
      conversation = Conversation.between([user1, user2])

      expect(conversation).to be_persisted
      expect(conversation.users).to include(user1)
      expect(conversation.users).to include(user2)
    end

    it "should not duplicate conversation between users" do
      conversation1 = Conversation.between([user1, user2])
      conversation2 = Conversation.between([user1, user2])

      expect(conversation1).to eq(conversation2)
    end
  end

  describe "not_user" do
    it "should return all users minus user" do
      conversation = Conversation.between([user1, user2])

      expect(conversation.other_users(user1)).to eq([user2])
    end
  end
 
end
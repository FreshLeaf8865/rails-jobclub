require "rails_helper"

RSpec.describe ConversationUser, type: :model do
  let(:user) { FactoryGirl.build(:user) }
  let(:conversation_user) { FactoryGirl.build(:conversation_user, user: user) }
  let(:conversation) { conversation_user.conversation}
  
  subject { conversation_user }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:conversation) }
  end

  describe "validations" do
    it { should validate_uniqueness_of(:user_id).scoped_to(:conversation_id) }
  end

  describe "update_last_read_at" do
    it "should update_last_read_at" do
      conversation_user.update_last_read_at
      expect(conversation_user.last_read_at).to be_present
    end
  end

  describe "unread_messages_count" do
    let(:other_user) { FactoryGirl.create(:user) }
    
    it "should calculate unread_messages_count" do
      message1 = FactoryGirl.create(:message, user: user, conversation: conversation)
      message2 = FactoryGirl.create(:message, user: other_user, conversation: conversation)
      message3 = FactoryGirl.create(:message, user: user, conversation: conversation)

      expect(conversation.conversation_users.count).to eq(2)
      
      conversation_user = conversation.conversation_users.first
      expect(conversation_user.unread_messages_count).to eq(1)

      other_conversation_user = conversation.conversation_users.last
      expect(other_conversation_user.unread_messages_count).to eq(1)

      conversation_user.update_unread_messages_count
      expect(conversation_user.unread_messages_count).to eq(1)

      message1.read_by!(other_user)
      message2.read_by!(user)

      conversation_user.update_unread_messages_count
      expect(conversation_user.unread_messages_count).to eq(0)

      expect(other_conversation_user.unread_messages_count).to eq(1)

      message3.read_by!(other_user)
      other_conversation_user.update_unread_messages_count
      expect(other_conversation_user.unread_messages_count).to eq(0)
    end
  end
 
end
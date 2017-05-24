require 'rails_helper'

RSpec.describe ConversationPolicy do

  subject { ConversationPolicy.new(user, conversation) }

  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:conversation) { FactoryGirl.build(:conversation, users: [user1,user2]) }
  
  context 'being a visitor' do
    let(:user) { nil }

    it { should forbid_action(:show) }
    it { should forbid_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being in the conversation' do
    let(:user) { user1 }
    it { should permit_action(:show) }
    # it { should permit_action(:create) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  context 'being an another user' do
    let(:user) { FactoryGirl.create(:user) }

    it { should forbid_action(:show) }
    # it { should permit_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being an admin' do
    let(:user) { FactoryGirl.create(:admin) }

    it { should forbid_action(:show) }
    it { should permit_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

end

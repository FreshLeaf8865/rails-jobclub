require 'rails_helper'

RSpec.describe UserRolePolicy do

  subject { UserRolePolicy.new(user, user_role) }

  let(:user) { FactoryGirl.create(:user) }
  let(:owner) { FactoryGirl.create(:user) }
  let(:user_role) { FactoryGirl.create(:user_role, user: owner) }
  
  context 'being a visitor' do
    let(:user) { nil }

    it { should permit_action(:show) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being the owner' do
    let(:user) { owner }
    it { should permit_action(:show) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  context 'being an another user' do
    let(:user) { FactoryGirl.create(:user) }

    it { should permit_action(:show) }
    it { should permit_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being an admin' do
    let(:user) { FactoryGirl.create(:admin) }

    it { should permit_action(:show) }
    it { should permit_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

end

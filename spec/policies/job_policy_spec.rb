require 'rails_helper'

RSpec.describe JobPolicy do

  subject { JobPolicy.new(user, job) }

  let(:job) { FactoryGirl.build(:job) }
  let(:user) { FactoryGirl.build(:user) }

  context 'being a visitor' do
    let(:user) { nil }

    it { should permit_action(:show) }
    it { should forbid_action(:create) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being the owner' do
    let(:user) { job.user }
    it { should permit_action(:show) }
    it { should permit_action(:create) }
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
    let(:user) { FactoryGirl.build(:admin) }

    it { should permit_action(:show) }
    it { should permit_action(:create) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

  # context 'being a moderator' do
  #   let(:user) { FactoryGirl.build(:moderator) }

  #   it { should permit_action(:show) }
  #   it { should permit_action(:create) }
  #   it { should permit_action(:update) }
  #   it { should forbid_action(:destroy) }
  # end

end

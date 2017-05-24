require 'rails_helper'

RSpec.describe SkillPolicy do

  subject { SkillPolicy.new(user, skill) }

  let(:skill) { FactoryGirl.build(:skill) }
  let(:user) { FactoryGirl.build(:user) }

  context 'being a visitor' do
    let(:user) { nil }

    it { should permit_action(:show) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being a user' do
    it { should permit_action(:show) }
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

  context 'being a moderator' do
    let(:user) { FactoryGirl.build(:moderator) }

    it { should permit_action(:show) }
    it { should permit_action(:create) }
    it { should permit_action(:update) }
    it { should forbid_action(:destroy) }
  end

end

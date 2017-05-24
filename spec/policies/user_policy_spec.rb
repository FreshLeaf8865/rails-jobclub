require 'rails_helper'

RSpec.describe UserPolicy do
  subject { UserPolicy.new(user, user) }

  let(:user) { FactoryGirl.build(:user) }
  let(:other_user) { FactoryGirl.build(:user) }

  context 'being a visitor' do
    let(:user) { nil }

    it { should permit_action(:create) }
    it { should permit_action(:show) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being a different user' do
    subject { UserPolicy.new(user, other_user) }
    it { should permit_action(:show) }
    it { should forbid_action(:edit) }
    it { should forbid_action(:update) }
    it { should forbid_action(:destroy) }
  end

  context 'being the user' do
    it { should permit_action(:show) }
    it { should permit_action(:edit) }
    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
  end

end

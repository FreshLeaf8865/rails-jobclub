require 'rails_helper'

RSpec.describe StoryPolicy do

  subject { StoryPolicy.new(user, story) }

  let(:user) { FactoryGirl.create(:user) }
  let(:owner) { FactoryGirl.create(:user) }
  let(:story) { FactoryGirl.create(:story, user: owner) }
  
  context 'drafts' do
    context 'being a visitor' do
      let(:user) { nil }

      it { should forbid_action(:show) }
      it { should forbid_action(:update) }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:publish) }
    end

    context 'being the owner' do
      let(:user) { owner }
      it { should permit_action(:show) }
      it { should permit_action(:update) }
      it { should permit_action(:destroy) }
      it { should permit_action(:publish) }
    end

    context 'being an another user' do
      let(:user) { FactoryGirl.create(:user) }

      it { should forbid_action(:show) }
      it { should forbid_action(:update) }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:publish) }
    end

    context 'being an admin' do
      let(:user) { FactoryGirl.create(:admin) }

      it { should permit_action(:show) }
      it { should permit_action(:update) }
      it { should forbid_action(:destroy) }
      it { should permit_action(:publish) }
    end
  end

  context 'published' do
    let(:story) { FactoryGirl.create(:story, user: owner, published_on: DateTime.now) }
    context 'being a visitor' do
      let(:user) { nil }

      it { should permit_action(:show) }
      it { should forbid_action(:update) }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:publish) }
    end

    context 'being the owner' do
      let(:user) { owner }
      it { should permit_action(:show) }
      it { should permit_action(:update) }
      it { should permit_action(:destroy) }
      it { should permit_action(:publish) }
    end

    context 'being an another user' do
      let(:user) { FactoryGirl.create(:user) }

      it { should permit_action(:show) }
      it { should permit_action(:create) }
      it { should forbid_action(:update) }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:publish) }
    end

    context 'being an admin' do
      let(:user) { FactoryGirl.create(:admin) }

      it { should permit_action(:show) }
      it { should permit_action(:create) }
      it { should permit_action(:update) }
      it { should forbid_action(:destroy) }
      it { should permit_action(:publish) }
    end
  end
end

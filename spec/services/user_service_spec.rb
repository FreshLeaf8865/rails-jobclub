require 'rails_helper'

RSpec.describe UserService do

  it "should create a valid admin user" do
    email = FactoryGirl.generate(:email)
    user = UserService.create_admin_user(email, FactoryGirl.generate(:password))

    expect(user.valid?).to eq(true)
    expect(user.persisted?).to eq(true)
    expect(user.is_admin).to eq(true)
  end

  it "should create a valid user" do
    email = FactoryGirl.generate(:email)
    user = UserService.create_user(email, FactoryGirl.generate(:password))

    expect(user.valid?).to eq(true)
    expect(user.persisted?).to eq(true)
    expect(user.is_admin).to eq(false)
  end

end

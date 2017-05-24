# Feature: Sign up
#   As a visitor
#   I want to sign up
#   So I can visit protected areas of the site
RSpec.feature 'Sign Up', :devise do

  # Scenario: Visitor can sign up with valid email address and password
  #   Given I am not signed in
  #   When I sign up with a valid email address and password
  #   Then I see a successful sign up message
  scenario 'visitor can sign up with valid email address, username and password' do
    sign_up_with('test@example.com', 'test', 'please123')
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  # Scenario: Visitor cannot sign up with invalid email address
  #   Given I am not signed in
  #   When I sign up with an invalid email address
  #   Then I see an invalid email message
  scenario 'visitor cannot sign up with invalid email address' do
    sign_up_with('bogus', 'test', 'please123')
    expect(page).to have_content 'is invalid'
  end

  # Scenario: Visitor cannot sign up without password
  #   Given I am not signed in
  #   When I sign up without a password
  #   Then I see a missing password message
  scenario 'visitor cannot sign up without password' do
    sign_up_with('test@example.com', 'test', '')
    expect(page).to have_content "can't be blank"
  end

  # Scenario: Visitor cannot sign up with a short password
  #   Given I am not signed in
  #   When I sign up with a short password
  #   Then I see a 'too short password' message
  scenario 'visitor cannot sign up with a short password' do
    sign_up_with('test@example.com', 'test', 'please')
    expect(page).to have_content "is too short"
  end

  # Scenario: Visitor cannot sign up without username
  #   Given I am not signed in
  #   When I sign up without a username
  #   Then I see a missing username message
  # scenario 'visitor cannot sign up without username' do
  #   sign_up_with('test@example.com', '', 'please123')
  #   expect(page).to have_content "can't be blank"
  # end
end

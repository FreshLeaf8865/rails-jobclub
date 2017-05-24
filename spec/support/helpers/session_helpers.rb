module Features
  module SessionHelpers

    def sign_up_with(email, name, password)
      visit new_user_registration_path
      submit_signup(email,name,password)
    end

    def submit_signup(email, name, password)
      fill_in 'Email', with: email
      fill_in 'Name', with: name
      fill_in 'Password', with: password
      click_button 'Sign Up'
    end

    def signin(email, password)
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Login'
    end
  end
end

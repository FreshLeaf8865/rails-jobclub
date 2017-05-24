class UserService

  def self.create_user(email, password)
    user = User.where(:email => email).first
    if user.nil?
      user = User.new(email: email)
    end
    user.password = user.password_confirmation = password
    user.save
    
    return user
  end

  def self.create_admin_user(email, password)
    user = create_user(email, password)

    user.is_admin = true
    user.save
    
    return user
  end
end

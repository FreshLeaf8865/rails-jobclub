class FacebookService

  def self.get_client
    @user ||= User.find_by(username: Rails.application.secrets.facebook_import_username || 'kidbombay')
    @graph ||=  self.get_client_for_user(@user)
  end

  def self.get_client_for_user(user)
    Koala::Facebook::API.new(user.get_fb_token)
  end

  def self.search_pages(query)
    self.get_client.search(query, {type: "page", fields: "id,name,picture,link",limit: 5})
  end

  def self.facebook_friends(user)
    client = get_client_for_user(user)
    client.get_connections("me", "friends")
  end

  def self.facebook_friends_users(user)
    users = []
    facebook_friends = self.facebook_friends(user)
    facebook_friends.each do |friend|
      fb_auth = Authentication.facebook.where(uid: friend["id"]).first
      users << fb_auth.user.id if fb_auth
    end

    User.where(id: users)
  end

  def self.mutual_follow_facebook_friends(user)
    users = self.facebook_friends_users(user)
    users.each do |u|
      user.follow(u)
      u.follow(user)
    end
  end


  
end
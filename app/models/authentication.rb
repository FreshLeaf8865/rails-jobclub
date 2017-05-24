class Authentication < ApplicationRecord
  # Constants
  FACEBOOK = "facebook"
  INSTAGRAM = "instagram"
  TWITTER = "twitter"
  LINKEDIN = 'linkedin'
  GOOGLE = 'google_oauth2'
  SPOTIFY = 'spotify'

  VALID_PROVIDERS = [
    FACEBOOK,
    INSTAGRAM,
    TWITTER,
    LINKEDIN,
    GOOGLE,
    SPOTIFY
  ]

  # Scopes
  scope :instagram, -> { where(provider: INSTAGRAM) }
  scope :facebook, -> { where(provider: FACEBOOK) }
  scope :twitter, -> { where(provider: TWITTER) }
  scope :linkedin, -> { where(provider: LINKEDIN) }
  scope :google, -> { where(provider: GOOGLE) }
  scope :spotify, -> { where(provider: SPOTIFY) }

  # Associations
  belongs_to :user, inverse_of: :authentications

  # Validations
  validates :user, :presence => true
  validates :uid, :presence => true,
                  :uniqueness => { :case_sensitive => false, :scope => :provider }
  validates :provider, :presence => true,
                            :inclusion => { :in => VALID_PROVIDERS, :message => "%{value} is not a valid type" }

  def from_omniauth(omniauth)
    self.omniauth_json =  omniauth.to_json
    self.provider =       omniauth['provider']
    self.uid =            omniauth['uid']
    self.token =          omniauth["credentials"]["token"]
    self.secret =         omniauth["credentials"]["secret"]
    self.refresh_token =  omniauth["credentials"]["refresh_token"]
    self.expires =        omniauth["credentials"]["expires"] == "true"

    date = omniauth["credentials"]["expires_at"].to_s
    self.expires_at =     DateTime.strptime(date,'%s') if date.present?

    if provider == LINKEDIN
      # linked doesn't return the username from omniauth
      # profile url is like http://www.linkedin.com/in/kidbombay
      profile_url = omniauth['info']["urls"]["public_profile"]
      self.username = profile_url.split("https://www.linkedin.com/in/")[1]
    else
      self.username = omniauth['info']["nickname"] if !omniauth['info']['nickname'].blank?
    end

  end

  rails_admin do
    show do
      configure(:omniauth_json, :string)
    end
  end
end

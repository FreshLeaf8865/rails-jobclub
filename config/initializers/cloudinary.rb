Cloudinary.config do |config|
  config.cloud_name = Rails.application.secrets.cloudinary_name
  config.api_key = Rails.application.secrets.cloudinary_key
  config.api_secret = Rails.application.secrets.cloudinary_secret
  config.cdn_subdomain = true
end
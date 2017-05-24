require 'dragonfly'
require 'cloudinary_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "33e65be86796185a3cd6928ae1a85a587d52e7012c18dac9f0a5599b0cf7d11c"

  url_format "/media/:job/:name"
  url_host Rails.application.secrets.domain_name

  if Rails.env.test?
    datastore :file,
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
  else
    datastore :cloudinary_store
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end

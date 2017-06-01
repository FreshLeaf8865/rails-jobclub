source 'https://rubygems.org'
ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.3'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
# gem 'turbolinks', '~> 5'

group :production do
  #gem 'heroku-deflater'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry-byebug'
  # gem 'guard'
  # gem 'guard-bundler', require: false
  # gem 'guard-rspec', require: false
  # gem 'guard-rails', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # gem 'listen', '~> 3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'terminal-notifier-guard', '~> 1.6.1'
  gem 'rails_layout'
  gem 'foreman'
  gem 'letter_opener'
  gem 'derailed'

  gem 'capistrano', '~> 3.7', '>= 3.7.1'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rvm'
end

group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'pundit-matchers'
  gem 'wisper-rspec', require: false
  gem 'capybara'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Custom Gems
gem 'haml-rails', '~> 0.9'
gem 'redis'
gem 'sidekiq'
gem 'bootstrap', '~> 4.0.0.alpha6'
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end
gem 'friendly_id', '~> 5.1.0'
gem 'devise'
gem 'pundit'
gem 'hashie', '~> 3.4.6'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-linkedin-oauth2', git: 'https://github.com/Devato/omniauth-linkedin-oauth2.git'
gem 'omniauth-google-oauth2'
gem 'sendgrid-ruby'
gem 'rails_admin', '~> 1.0'
gem 'wicked'
gem 'counter_culture', '1.6.2'
gem 'dragonfly', '~> 1.1.1'
gem 'cloudinary'
gem 'dalli'
gem 'memcachier'
gem 'kaminari'
gem 'acts_as_list'
gem 'acts_as_tree'
gem 'active_model_serializers', '~> 0.10.0'
gem 'rollbar'
gem 'newrelic_rpm'
gem 'wisper'
gem 'public_activity'
gem 'cocoon'
gem 'validate_url'
gem 'koala'
gem 'pg_search'
gem 'impressionist'
gem 'nilify_blanks'
gem 'auto_strip_attributes'
gem 'acts-as-taggable-array-on', :github => 'kidbombay/acts-as-taggable-array-on'
gem 'meta-tags'
gem 'chronic'
gem 'sitemap_generator'
gem 'fog-aws'
gem 'nav_lynx'
gem 'acts_as_follower', github: 'tcocca/acts_as_follower', branch: 'master'
gem 'redcarpet'
gem 'local_time'
gem 'jquery-infinite-pages'
gem 'rinku'
gem 'one_signal'
gem 'hirefire-resource'
gem 'capistrano-rails-logs-tail', :github => 'FindHotel/capistrano-rails-logs-tail'
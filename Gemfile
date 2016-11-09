source 'https://rubygems.org'

ruby '2.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
# Uglifier requires a JavaScript runtime, e.g. therubyracer
# See https://github.com/rails/execjs for a list of available runtimes.
# gem 'therubyracer', '~> 0.12.2', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster.
# See https://github.com/rails/turbolinks
gem 'turbolinks'
# Fixes problems using turbolinks with custom JS
# See https://github.com/kossnocorp/jquery.turbolinks
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'

# Build JSON APIs with ease.
# See https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

# for Windows users
# gem 'nokogiri', '1.6.7.rc3', platforms: [:mswin, :mingw, :x64_mingw]
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

# Authentication
gem 'devise'
# openID Authentication
gem 'devise_openid_authenticatable'

# Use Bootstrap (app/assets/stylesheets) for app styling
# Also provides some nifty helpers:
# https://github.com/seyhunak/twitter-bootstrap-rails#using-helpers
gem 'twitter-bootstrap-rails'
# Boostrap-syle view for devise
gem 'devise-bootstrap-views'
# Integrates Bootstrap Tooltip library with Rails asset pipeline
# gem 'bootstrap-tooltip-rails'
# Integrates a bootstrap-style datepicker with Rails asset pipeline
# gem 'bootstrap-datepicker-rails'

# Select2 dropdown replacement featuring autocomplete
# gem 'select2-rails'

# performance management
gem 'newrelic_rpm'
# Exception Tracking using Errbit
gem 'airbrake'

# to parse date parameters from ui
gem "delocalize"
# American style month/day/year parsing for ruby 1.9
# https://github.com/jeremyevans/ruby-american_date
gem "american_date"

# Authorisation library, define who is allowed what
# See https://github.com/CanCanCommunity/cancancan
gem 'cancancan'

# Create filters easily with scopes
# See https://github.com/plataformatec/has_scope
gem 'has_scope'

# Static code analysis
gem 'rubocop', '~> 0.29.1'

# DSL for building forms
# See https://github.com/plataformatec/simple_form
# gem 'simple_form'

# coveralls.io
gem 'coveralls', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails', '~> 3.2'
  gem 'capybara', '~> 2.5'
  # gem 'database_cleaner'
  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background.
  # See https://github.com/rails/spring
  gem 'spring'

  gem 'better_errors', '~> 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'

  # an IRB alternative and runtime developer console
  gem 'pry'
  gem 'pry-rails'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Add a comment summarizing the current schema for models and others
  # usage: annotate
  gem 'annotate'
  
  # opens sent emails in a new browser tab
  # gem "letter_opener"
end

group :test do
  # Coverage information
  gem 'simplecov'
  gem "codeclimate-test-reporter", "~> 1.0.0"
  # Explicitly set parser version, to remove warnings
  # Might lead to problems with other gems that require higher parser versions
  # In that case, update to a newer Ruby version
  gem 'parser', '~> 2.2.2.5'
  # Stubbing external calls by blocking traffic with WebMock.disable_net_connect! or allow:
  # gem 'webmock'
end

group :production do
  # Use Puma web server
  # https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
  gem 'puma'
  # Use Postgresql in production
  gem 'pg'
  # Logging on Heroku with Rails 4
  # https://devcenter.heroku.com/articles/rails4
  gem 'rails_12factor'
end

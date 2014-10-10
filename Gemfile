source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'

# Adds bootstrap
gem 'bootstrap-sass', '3.2.0.0'

# Use SCSS for stylesheets
gem 'sass-rails', '5.0.0.beta1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.5.1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '4.0.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.1.2'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.1.3'

# Uses rails html-sanitizer
gem 'rails-html-sanitizer', '1.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '0.4.0',          group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.7'

# Allows to make sample users with semi-realistic names and email addresses
gem 'faker',  '1.4.2'

# For image uploading, resizing and uploading in production
gem 'carrierwave',  '0.10.0'
gem 'mini_magick',  '3.8.0'
gem 'fog',  '1.23.0'

# Simple and robust pagination
gem 'will_paginate',   '3.0.7'
gem 'bootstrap-will_paginate',  '0.0.10'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Adds gems for development environment
group :development, :test do
  gem 'sqlite3',     '1.3.9'
  gem 'byebug',      '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring',      '1.1.3'
end

# Adds gems for testing purposes
group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

# Adds gems for production environment
group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
  gem 'unicorn',        '4.8.3'
end

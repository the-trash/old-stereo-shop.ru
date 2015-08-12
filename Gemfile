source 'http://rubygems.org'

gem 'rails'
gem 'rails_config', '0.2.5'

## Database adapter
gem 'pg', '0.18.2'

## ActiveAdmin
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'activeadmin-dragonfly', github: 'stefanoverna/activeadmin-dragonfly'
gem 'activeadmin-sortable-tree', github: 'nebirhos/activeadmin-sortable-tree', branch: 'master'
gem 'activeadmin-wysihtml5', github: 'stefanoverna/activeadmin-wysihtml5'

gem 'carrierwave'
gem 'carrierwave-size-validator'
gem 'normalize-rails'
gem 'rmagick', require: 'RMagick'

## Assets
gem 'autoprefixer-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'compass-rails'
gem 'errgent', github: 'route/errgent' # for error pages
gem 'html5shiv-js-rails' # TODO install it with bower
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'

## Cache store
gem 'redis-namespace', '>= 1.0'
gem 'redis-rails'
gem 'redis-store'

## Template
gem 'haml'
gem 'sanitize'
gem 'unicode'

gem 'simple_captcha2', require: 'simple_captcha'
gem 'browser'

## Authentication and authorization
gem 'devise', git: 'git://github.com/plataformatec/devise.git'
gem 'devise-async'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'pundit'

gem 'activemerchant', '1.43.3', require: 'active_merchant'
gem 'activerecord-import'
gem 'acts_as_list'
gem 'ancestry'
gem 'annotate', github: 'ctran/annotate_models'
gem 'bootstrap_flash_messages', '~> 1.0.0'
gem 'bower-rails'
gem 'breadcrumbs_on_rails'
gem 'charlock_holmes'
gem 'draper'
gem 'friendly_id', '~> 5.0.4'
gem 'sitemap_generator'
gem 'gon'
gem 'hstore_accessor'
gem 'image_suckr'
gem 'memoist'
gem 'newrelic_rpm'
gem 'rabl'
gem 'ruby-progressbar'
gem 'sidekiq'
gem 'sidetiq', '0.6.1'
# For sidekiq
gem 'sinatra', require: false
gem 'slim'
gem 'state_machine'
gem 'unicorn'
gem 'will_paginate'

group :development do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller' # need for better_errors
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'capistrano', '~> 3.2.1'
  gem 'capistrano-bundler', '~> 1.1.3'
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
  gem 'capistrano3-nginx'
  gem 'capistrano3-unicorn'
  gem 'foreman'
  gem 'fuubar'
  gem 'letter_opener'
  gem 'meta_request'
  gem 'thin'
  gem 'traceroute'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-rails'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'pickle'
  gem 'poltergeist'
  gem 'rspec'
  gem 'rspec-core'
  gem 'rspec-expectations'
  gem 'rspec-its'
  gem 'rspec-mocks'
  gem 'rspec-nc'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spring-commands-rspec'
  gem 'test_after_commit'
end

gem 'seedbank', github: 'james2m/seedbank', group: [:development, :test, :staging]

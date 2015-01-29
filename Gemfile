source 'https://rubygems.org'

gem 'rails'
gem 'rails_config', '0.2.5'

## Database adapter
gem 'pg'

## ActiveAdmin
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'activeadmin-dragonfly', github: 'stefanoverna/activeadmin-dragonfly'
gem 'activeadmin-select2', github: 'mfairburn/activeadmin-select2'
gem 'activeadmin-sortable-tree', github: 'nebirhos/activeadmin-sortable-tree', branch: 'master'
gem 'activeadmin-wysihtml5', github: 'stefanoverna/activeadmin-wysihtml5'

gem 'carrierwave'
gem 'carrierwave-size-validator'
gem 'ckeditor'
gem 'normalize-rails'
gem 'paper_trail'
gem 'phony_rails'
gem 'rmagick', require: 'RMagick'
gem 'validates_timeliness', '~> 3.0'

## Assets
gem 'autoprefixer-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'compass-rails'
gem 'errgent', github: 'route/errgent' # for error pages
gem 'html5shiv-js-rails'
gem 'jquery-rails'
gem 'oily_png'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

## Cache store
gem 'redis-namespace', '>= 1.0'
gem 'redis-rails'
gem 'redis-store'

## Template
gem 'haml'
gem 'haml-rails'
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

gem 'activerecord-import'
gem 'acts_as_list'
gem 'ancestry'
gem 'bootstrap_flash_messages', '~> 1.0.0'
gem 'breadcrumbs_on_rails'
gem 'friendly_id', '~> 5.0.4'
gem 'gon'
gem 'hstore_accessor'
gem 'image_suckr'
gem 'jquery-ui-rails'
gem 'memoist'
gem 'rabl'
gem 'ruby-progressbar'
gem 'select2-rails'
gem 'sidekiq'
gem 'sidetiq'
# For sidekiq
gem 'sinatra', require: false
gem 'slim'
gem 'state_machine'
gem 'unicorn'
gem 'will_paginate'

group :development do
  gem 'annotate', github: 'ctran/annotate_models'
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
  gem 'guard'
  gem 'guard-livereload', require: false
  gem 'letter_opener'
  gem 'meta_request'
  gem 'pry'
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'thin'
  gem 'traceroute'
end

group :development, :test do
  gem 'faker'
  gem 'guard-spring'
  gem 'spring'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec'
  gem 'rspec-core'
  gem 'rspec-expectations'
  gem 'rspec-its'
  gem 'rspec-mocks'
  gem 'rspec-nc'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spring-commands-rspec'
end

gem 'seedbank', github: 'james2m/seedbank', group: [:development, :test, :staging]

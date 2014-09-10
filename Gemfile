source 'https://rubygems.org'

gem 'rails', '4.1.5'
gem 'rails_config', '0.2.5'

## Database adapter
gem 'pg'

## ActiveAdmin
gem 'activeadmin', github: 'activeadmin'
gem 'carrierwave'
gem 'carrierwave-size-validator'
gem 'ckeditor'
gem 'mini_magick'
gem 'normalize-rails'
gem 'paper_trail'
gem 'phony_rails'
gem 'rmagick', require: 'RMagick'
gem 'validates_timeliness', '~> 3.0'

## Assets
gem 'autoprefixer-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'errgent', github: 'route/errgent' # for error pages
gem 'jquery-rails'
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

gem 'sidekiq'

group :development do
  gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'thin'
  gem 'foreman'
  gem 'quiet_assets'

  gem 'spring'
end

group :development, :test do
  gem 'zeus'

  gem 'rspec'
  gem 'rspec-core'
  gem 'rspec-rails'
  gem 'rspec-mocks'
  gem 'rspec-expectations'
  gem 'rspec-nc'
  gem 'shoulda-matchers'

  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
  gem 'fuubar'
end
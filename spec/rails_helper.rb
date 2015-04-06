# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'spec_helper'
require 'mailer_helper'
require 'rspec/rails'
require 'sidekiq/testing'
require 'pundit/rspec'

Dir[Rails.root.join("spec/concerns/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.failure_color = :magenta
  config.tty = true
  config.color = true

  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include MailerHelper, type: :mailer

  Sidekiq::Testing.fake!

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    Sidekiq::Worker.clear_all
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:all) do
    FileUtils.rm_rf(Dir["#{ Rails.root }/public/uploads/imports/test/[^.]*"])
  end
end

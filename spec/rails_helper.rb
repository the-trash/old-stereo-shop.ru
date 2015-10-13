ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'spec_helper'
require 'mailer_helper'
require 'rspec/rails'
require 'devise'
require 'sidekiq/testing'
require 'pundit/rspec'
require 'webmock/rspec'

Dir[Rails.root.join("spec/concerns/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect! allow_localhost: true

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.failure_color = :magenta
  config.tty = true
  config.color = true

  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include MailerHelper, type: :mailer
  config.include Devise::TestHelpers, type: :controller

  Sidekiq::Testing.inline!

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    Sidekiq::Worker.clear_all
    ActionMailer::Base.deliveries.clear
    # central bank EURO
    stub_request(:get, 'http://www.cbr.ru/scripts/XML_daily.asp')
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Host'=>'www.cbr.ru',
          'User-Agent'=>'Ruby'
        },
        query: { date_req: "#{I18n.l(Date.today, format: :main)}" }
      )
      .to_return(
        status: 200,
        body: '<?xml version="1.0" encoding="windows-1251" ?>
          <ValCurs Date="' + I18n.l(Date.today, format: :main) + '" name="Foreign Currency Market">
            <Valute ID="' + Settings.central_bank.currency_code.eur + '">
              <NumCode>978</NumCode>
              <CharCode>EUR</CharCode>
              <Nominal>1</Nominal>
              <Name>Евро</Name>
              <Value>26,8343</Value>
            </Valute>
          </ValCurs>'
      )
  end

  config.after(:each) do
    DatabaseCleaner.clean
    FactoryGirl.reset_shared_admin
  end

  config.after(:all) do
    FileUtils.rm_rf(Dir["#{ Rails.root }/public/uploads/imports/test/[^.]*"])
  end
end

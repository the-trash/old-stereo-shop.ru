require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stereoshop
  class Application < Rails::Application
    config.time_zone = 'Moscow'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir["config/locales/**/*.{rb,yml}"]
    config.i18n.available_locales = %i(ru)
    config.i18n.default_locale = :ru

    config.generators do |g|
      g.helper false
      g.assets false
      g.decorator false

      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'

      g.view_specs false
      g.helper_specs false
      g.view_specs false
      g.controller_spec true
      g.model_spec true
    end

    %w(uploaders forms presenters queries workers views/mailers).each do |folder_path|
      config.autoload_paths += Dir["#{ config.root }/app/#{folder_path}/**/"]
    end

    config.autoload_paths += Dir["#{ config.root }/lib/**/"]

    config.assets.initialize_on_precompile = true

    ActionMailer::Base.prepend_view_path("#{ config.root }/app/views/mailers/")

    CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

    ActiveMerchant::Billing::Base.mode = Settings.yandex_cashbox.mode
  end
end

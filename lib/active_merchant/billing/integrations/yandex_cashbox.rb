module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:

      # Documentation: https://money.yandex.ru/doc.xml?id=526537
      module YandexCashbox
        autoload :Helper, File.dirname(__FILE__) + '/yandex_cashbox/helper.rb'
        autoload :Notification, File.dirname(__FILE__) + '/yandex_cashbox/notification.rb'
        autoload :Return, File.dirname(__FILE__) + '/yandex_cashbox/return.rb'

        # Overwrite this if you want to change the Yandex Cashbox test url
        mattr_accessor :test_url
        self.test_url = Settings.yandex_cashbox.url.test

        # Overwrite this if you want to change the Yandex Cashbox production url
        mattr_accessor :production_url
        self.production_url = Settings.yandex_cashbox.url.production

        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
          when :production
            self.production_url
          when :test
            self.test_url
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end

        def self.helper(order, account, options = {})
          Helper.new(order, account, options)
        end

        def self.notification(query_string, options = {})
          Notification.new(query_string, options)
        end

        def self.return(query_string)
          Return.new(query_string)
        end
      end
    end
  end
end

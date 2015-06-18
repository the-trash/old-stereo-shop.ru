module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module YandexCashbox
        class Helper < ActiveMerchant::Billing::Integrations::Helper
          # required
          mapping :account, 'shopId'
          mapping :scid, 'scid'
          mapping :amount, 'sum'
          mapping :customer_number, 'customerNumber'

          # not required
          mapping :order_number, 'orderNumber'
          mapping :payment_type, 'paymentType'
          mapping :currency, 'orderSumCurrencyPaycash'

          mapping :urls, {
            success: 'shopSuccessURL',
            fail: 'shopFailURL'
          }

          mapping :customer, {
            phone: 'cps_phone',
            email: 'cps_email'
          }
        end
      end
    end
  end
end

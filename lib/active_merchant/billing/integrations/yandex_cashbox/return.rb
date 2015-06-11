module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module YandexCashbox
        class Return < ActiveMerchant::Billing::Integrations::Return
          def item_id
            params['invoiceId']
          end
        end
      end
    end
  end
end

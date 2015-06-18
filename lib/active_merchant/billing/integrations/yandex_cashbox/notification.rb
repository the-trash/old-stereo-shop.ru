module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module YandexCashbox
        class Notification < ActiveMerchant::Billing::Integrations::Notification
          def production_ips
            Settings.yandex_cashbox.production_ips
          end

          def action
            params['payment_action']
          end

          def amount
            BigDecimal.new(gross)
          end

          def gross
            params['orderSumAmount']
          end

          def order_sum_currency_paycash
            params['orderSumCurrencyPaycash']
          end

          def order_sum_bank_paycash
            params['orderSumBankPaycash']
          end

          def invoice_id
            params['invoiceId']
          end

          def security_key
            params['md5']
          end

          def customer_number
            Sanitize.fragment params['customerNumber']
          end

          def customer
            User.find_by(email: customer_number)
          end

          # action;orderSumAmount;orderSumCurrencyPaycash;orderSumBankPaycash;shopId;invoiceId;customerNumber;shopPassword
          def generate_signature
            Digest::MD5.hexdigest \
              [
                action,
                gross,
                order_sum_currency_paycash,
                order_sum_bank_paycash,
                Settings.yandex_cashbox.shop_id,
                invoice_id,
                customer.try(:email),
                Settings.yandex_cashbox.shop_password
              ].compact.join(';')
          end

          def acknowledge?
            security_key == generate_signature
          end

          def performed_date_time
            Time.zone.now
          end

          def request_date_time
            params['requestDatetime']
          end

          def response_content_type
            'application/xml'
          end

          def success_response(*args)
            <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<#{action}Response performedDatetime="#{performed_date_time}"
code="0" invoiceId="#{invoice_id}"
shopId="#{Settings.yandex_cashbox.shop_id}"/>
            XML
          end

          def error_response(error_code, options = {})
            <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<#{action}Response performedDatetime="#{performed_date_time}"
code="#{error_code}" invoiceId="#{invoice_id}"
shopId="#{Settings.yandex_cashbox.shop_id}"
message="#{options[:message]}"/>
            XML
          end
        end
      end
    end
  end
end

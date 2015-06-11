FactoryGirl.define do
  factory :payment_transaction do
    order
    invoice_id { Faker::Number.number(4) }
    shop_id { Faker::Number.number(4) }
    payment_payer_code { Faker::Number.number(4) }
    order_sum_currency_paycash { Faker::Number.number(4) }
    shop_sum_currency_paycash { Faker::Number.number(4) }
    order_sum_bank_paycash { Faker::Number.number(4) }
    shop_sum_bank_paycash { Faker::Number.number(4) }
    order_sum_amount { Faker::Number.number(4) }
    shop_sum_amount { Faker::Number.number(4) }
    customer_number { Faker::Internet.safe_email }
    payment_type 'AC'
    cps_user_country_code { Faker::Address.country_code }
    md5 { Digest::MD5.hexdigest(Faker::Number.number(4)) }
    request_datetime { Faker::Date.between(2.days.ago, Date.today) }
    order_created_datetime { Faker::Date.between(2.days.ago, Date.today) }
  end
end

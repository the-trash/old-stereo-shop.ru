# == Schema Information
#
# Table name: payment_transactions
#
#  id                         :integer          not null, primary key
#  invoice_id                 :integer
#  shop_id                    :integer
#  order_number               :integer
#  order_sum_currency_paycash :integer
#  shop_sum_currency_paycash  :integer
#  order_sum_bank_paycash     :integer
#  shop_sum_bank_paycash      :integer
#  order_sum_amount           :decimal(10, 2)   default(0.0), not null
#  shop_sum_amount            :decimal(10, 2)   default(0.0), not null
#  payment_payer_code         :string(255)
#  customer_number            :string(255)
#  payment_type               :string(255)
#  cps_user_country_code      :string(255)
#  md5                        :string(255)
#  request_datetime           :datetime
#  order_created_datetime     :datetime
#  created_at                 :datetime
#  updated_at                 :datetime
#
# Indexes
#
#  index_payment_transactions_on_order_number  (order_number)
#

class PaymentTransaction < ActiveRecord::Base
  belongs_to :order, foreign_key: 'order_number'
end

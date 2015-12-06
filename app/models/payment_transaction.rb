# == Schema Information
#
# Table name: payment_transactions
#
#  id                         :integer          not null, primary key
#  shop_id                    :integer
#  order_number               :integer
#  order_sum_currency_paycash :integer
#  shop_sum_currency_paycash  :integer
#  order_sum_bank_paycash     :integer
#  shop_sum_bank_paycash      :integer
#  order_sum_amount           :decimal(10, 2)   default(0.0), not null
#  shop_sum_amount            :decimal(10, 2)   default(0.0), not null
#  invoice_id                 :string
#  payment_payer_code         :string
#  customer_number            :string
#  payment_type               :string
#  cps_user_country_code      :string
#  md5                        :string
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

class CreatePaymentTransactions < ActiveRecord::Migration
  def change
    create_table :payment_transactions do |t|
      t.integer :invoice_id
      t.integer :shop_id
      t.integer :order_number
      t.integer :order_sum_currency_paycash
      t.integer :shop_sum_currency_paycash
      t.integer :order_sum_bank_paycash
      t.integer :shop_sum_bank_paycash


      t.decimal :order_sum_amount, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :shop_sum_amount, precision: 10, scale: 2, default: 0.0, null: false

      t.string :payment_payer_code
      t.string :customer_number
      t.string :payment_type
      t.string :cps_user_country_code
      t.string :md5

      t.datetime :request_datetime
      t.datetime :order_created_datetime

      t.timestamps
    end

    add_index :payment_transactions, :order_number
  end
end

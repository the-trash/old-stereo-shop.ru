class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true
      t.belongs_to :cart, index: true
      t.belongs_to :city, index: true

      t.string :state
      t.integer :step, default: 0

      t.integer :delivery, default: 0
      t.integer :payment, default: 0

      t.string :post_index
      t.string :user_name
      t.string :phone
      t.text :address

      t.hstore :cashless_info
      t.string :file

      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end

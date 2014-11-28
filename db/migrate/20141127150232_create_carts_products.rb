class CreateCartsProducts < ActiveRecord::Migration
  def change
    create_table :carts_products do |t|
      t.belongs_to :cart, index: true
      t.belongs_to :product, index: true
      t.belongs_to :order, index: true
      t.integer :quantity, default: 1
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0, null: false
    end

    add_index :carts_products, [:cart_id, :product_id], unique: true
  end
end

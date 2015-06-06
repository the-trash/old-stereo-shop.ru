class AddColumnCurrentProductPriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :current_product_price, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end

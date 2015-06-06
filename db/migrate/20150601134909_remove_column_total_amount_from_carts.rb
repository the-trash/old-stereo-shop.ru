class RemoveColumnTotalAmountFromCarts < ActiveRecord::Migration
  def up
    remove_column :carts, :total_amount
  end

  def down
    add_column :carts, :total_amount, :decimal, precision: 10, scale: 2, default: 0.0, null: false 
  end
end

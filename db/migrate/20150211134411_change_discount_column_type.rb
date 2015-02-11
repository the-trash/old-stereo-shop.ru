class ChangeDiscountColumnType < ActiveRecord::Migration
  def up
    change_column :products, :discount, :integer, default: 0
  end

  def down
    change_column :products, :discount, :float, precision: 10, scale: 2, default: 0.0, null: false
  end
end

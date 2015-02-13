class AddColumnForProductEuroRate < ActiveRecord::Migration
  def change
    add_column :products, :euro_rate, :decimal, precision: 10, scale: 2, default: 0.0, null: false
  end
end

class AddColumnToProductFixPrice < ActiveRecord::Migration
  def change
    add_column :products, :fix_price, :boolean, default: false
  end
end

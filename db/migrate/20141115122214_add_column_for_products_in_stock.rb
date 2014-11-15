class AddColumnForProductsInStock < ActiveRecord::Migration
  def change
    add_column :products, :in_stock, :boolean, default: true
  end
end

class AddColumnForProductCategoriesSale < ActiveRecord::Migration
  def change
    add_column :product_categories, :sale, :boolean, default: :false
    add_column :product_categories, :sale_products_count, :integer, default: 0
  end
end

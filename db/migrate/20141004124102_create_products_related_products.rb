class CreateProductsRelatedProducts < ActiveRecord::Migration
  def change
    create_table :products_related_products, id: false do |t|
      t.belongs_to :product, index: true
      t.belongs_to :related_product, index: true
    end
  end
end

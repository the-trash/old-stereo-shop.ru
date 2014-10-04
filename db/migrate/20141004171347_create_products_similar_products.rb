class CreateProductsSimilarProducts < ActiveRecord::Migration
  def change
    create_table :products_similar_products, id: false do |t|
      t.belongs_to :product, index: true
      t.belongs_to :similar_product, index: true
    end
  end
end

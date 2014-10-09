class AddColumnForProductsPublishedReviewsCount < ActiveRecord::Migration
  def change
    change_column :reviews, :state, :integer, default: 3

    add_column :products, :published_reviews_count, :integer, default: 0
    add_column :products, :removed_reviews_count, :integer, default: 0
    add_column :products, :moderated_reviews_count, :integer, default: 0

    add_column :product_categories, :published_products_count, :integer, default: 0
    add_column :product_categories, :removed_products_count, :integer, default: 0
    add_column :product_categories, :products_count, :integer, default: 0
  end
end

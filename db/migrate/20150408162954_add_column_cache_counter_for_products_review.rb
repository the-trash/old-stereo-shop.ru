class AddColumnCacheCounterForProductsReview < ActiveRecord::Migration
  def change
    add_column :products, :draft_reviews_count, :integer, default: 0
  end
end

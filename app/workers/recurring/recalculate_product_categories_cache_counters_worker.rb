class Recurring::RecalculateProductCategoriesCacheCountersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { hourly(2) }

  def perform
    ProductCategory.find_each do |product_category|
      published_products_count = product_category.published_products.count
      draft_products_count     = product_category.draft_products.count
      removed_products_count   = product_category.removed_products.count
      moderated_products_count = product_category.moderated_products.count

      product_category.update_columns \
        published_products_count: published_products_count,
        removed_products_count: removed_products_count,
        moderated_products_count: moderated_products_count,
        draft_products_count: draft_products_count
    end
  end
end

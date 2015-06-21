class Recurring::RecalculateProductsReviewsCacheCountersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { hourly(2) }

  def perform
    Product.find_each do |product|
      published_reviews_count = product.published_reviews.count
      removed_reviews_count   = product.removed_reviews.count
      moderated_reviews_count = product.moderated_reviews.count
      draft_reviews_count     = product.draft_reviews.count

      product.update_columns \
        published_reviews_count: published_reviews_count,
        removed_reviews_count: removed_reviews_count,
        moderated_reviews_count: moderated_reviews_count,
        draft_reviews_count: draft_reviews_count
    end
  end
end

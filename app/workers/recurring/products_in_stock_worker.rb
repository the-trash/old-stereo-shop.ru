class Recurring::ProductsInStockWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { hourly.minute_of_hour(0, 15, 30, 45, 60) }

  def perform
    has_in_store_product_ids = Product.published.has_in_stores.pluck(:id)
    Product.where("id NOT IN (?)", has_in_store_product_ids).update_all(in_stock: false)
    Product.where(id: has_in_store_product_ids, in_stock: false).update_all(in_stock: true)
  end
end

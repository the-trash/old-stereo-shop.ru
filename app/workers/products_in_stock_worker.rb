class ProductsInStockWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { minutely(15) }

  def perform
    products_for_update =
      [].tap do |a|
        Product.published.includes(:products_stores).find_each do |product|
          a << product if product.products_stores.sum(:count) == 0 && product.in_stock
        end
      end

    Product.where(id: products_for_update.map(&:id)).update_all(in_stock: false)
  end
end

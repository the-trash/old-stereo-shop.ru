class SaleProductCategoriesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options retry: 5, unique: true

  recurrence { minutely(5) }

  def perform
    ProductCategory.published.includes(:products).find_each do |category|
      sale_products = category.products.published.with_discount

      category.update_columns({
        sale: sale_products.present?,
        sale_products_count: sale_products.size
      })
    end
  end
end

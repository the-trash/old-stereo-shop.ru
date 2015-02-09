class ProductImportWorker
  include Sidekiq::Worker

  def perform product_import_id
    Product::Import.find(product_import_id).complete!
  end
end

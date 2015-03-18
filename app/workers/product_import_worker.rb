class ProductImportWorker
  include Sidekiq::Worker

  def perform product_import_id
    import = Product::Import.find(product_import_id)

    import.import!
    import.complete!
  end
end

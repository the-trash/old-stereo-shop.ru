class Import::Main < Import::BaseImport
  delegate :meta, :title, :sku, :price, :discount, :euro_price, :description, to: :import_entry

  def params
    main_params.
      merge!(import_product_category.params).
      merge!(import_brand.params).
      merge!({ meta: import_meta.params })
  end

  private

  def import_meta
    Import::Meta.new(import_entry)
  end

  def import_product_category
    Import::ProductCategory.new
  end

  def import_brand
    Import::Brand.new(import_entry)
  end

  def main_params
    {
      title: title,
      description: description,
      sku: sku,
      price: price,
      discount: discount,
      euro_price: euro_price,
      weight: 0
    }
  end
end

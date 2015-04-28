class Import::ProductCategory < Import::BaseImport
  def product_category
    existing_product_category || create_product_category
  end

  def params
    { product_category_id: product_category.id }
  end

  private

  def existing_product_category
    ProductCategory.find_by(title: product_category_title)
  end

  def create_product_category
    ProductCategory.create(title: product_category_title)
  end

  def product_category_title
    @product_category_title ||= I18n.t('product_category_for_import')
  end
end

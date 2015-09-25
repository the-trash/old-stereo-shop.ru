class ProductCategoriesController < FrontController
  before_action :set_breadcrumbs_and_products_instance, only: [:sale, :sale_product_category]

  inherit_resources
  actions :show, :sale_product_category

  def show
    @products = products_collection_query_helper.all
    @brands = Brand.published.with_published_products.by_product_category(resource.id).order_by_position

    breadcrumbs_with_ancestors(resource)
  end

  def sale
    @products = @products_without_paginate.paginate(page: params[:page], per_page: Settings.pagination.products)
  end

  def sale_product_category
    @products_without_paginate_by_category = product_category_products.published.with_discount
    add_breadcrumb "#{ resource.title } (#{ @products_without_paginate_by_category.size })", [:sale, resource]

    @products = @products_without_paginate_by_category.paginate(page: params[:page], per_page: Settings.pagination.products)
    render :sale
  end

  private

  def set_breadcrumbs_and_products_instance
    @products_without_paginate = Product.published.with_discount

    add_breadcrumb I18n.t('controllers.product_categories.sale.all_products', count: @products_without_paginate.size), [:sale, :product_categories]
  end

  def products_collection_query_helper
    Products::IndexQuery.new product_category_products, params
  end

  def product_category_products
    @product_category_products ||= resource.products
  end
end

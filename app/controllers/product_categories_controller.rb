class ProductCategoriesController < FrontController
  inherit_resources
  actions :show, :sale_product_category

  def show
    @products = resource.products.includes(:photos, characteristics_products: :characteristic).published

    @products = @products.by_brand(params[:brand_id]) if params[:brand_id].to_i != 0
    @products = @products.sort_by(params[:sort_by]) if params[:sort_by].present?

    @products = @products.paginate(page: params[:page], per_page: Settings.pagination.products)

    @brands = Brand.published

    breadcrumbs_with_ancestors(resource)
  end

  def sale
    @products_without_paginate = Product.published.with_discount

    add_breadcrumb I18n.t('controllers.product_categories.sale.all_products', count: @products_without_paginate.size), [:sale, :product_categories]

    @products = @products_without_paginate.paginate(page: params[:page], per_page: Settings.pagination.products)
  end

  def sale_product_category
    @products_without_paginate = Product.published.with_discount
    add_breadcrumb I18n.t('controllers.product_categories.sale.all_products', count: @products_without_paginate.size), [:sale, :product_categories]

    @products_without_paginate_by_category = resource.products.published.with_discount
    add_breadcrumb "#{ resource.title } (#{ @products_without_paginate_by_category.size })", [:sale, resource]

    @products = @products_without_paginate_by_category.paginate(page: params[:page], per_page: Settings.pagination.products)
    render :sale, locales: { with_resource: true }
  end
end

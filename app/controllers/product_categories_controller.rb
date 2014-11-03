class ProductCategoriesController < FrontController
  inherit_resources
  actions :show

  def show
    @products =
      resource.products.includes(characteristics_products: :characteristic).published
        .paginate(page: params[:page], per_page: Settings.pagination.products)

    @brands = Brand.published

    breadcrumbs_with_ancestors(resource)
  end
end

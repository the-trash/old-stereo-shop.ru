class ProductCategoriesController < FrontController
  inherit_resources
  actions :show

  def show
    @products = resource.products.includes(:photos, characteristics_products: :characteristic).published

    @products = @products.by_brand(params[:brand_id]) if params[:brand_id].to_i != 0
    @products = @products.sort_by(params[:sort_by]) if params[:sort_by].present?

    @products = @products.paginate(page: params[:page], per_page: Settings.pagination.products)

    @brands = Brand.published

    breadcrumbs_with_ancestors(resource)
  end
end

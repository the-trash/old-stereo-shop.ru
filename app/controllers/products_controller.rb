class ProductsController < FrontController
  inherit_resources

  actions :index, :show

  def show
    @product_category = resource.product_category
    @stores = resource.products_stores
    breadcrumbs_with_ancestors(@product_category)

    show!
  end
end

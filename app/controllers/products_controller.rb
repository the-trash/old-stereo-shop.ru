class ProductsController < FrontController
  inherit_resources

  actions :index, :show

  def show
    @product_category = resource.product_category
    @stores           = resource.make_stores
    @characteristics  = resource.make_characteristics_tree
    @related_products = resource.related_products
    @similar_products = resource.similar_products

    breadcrumbs_with_ancestors(@product_category, resource)

    show!
  end
end

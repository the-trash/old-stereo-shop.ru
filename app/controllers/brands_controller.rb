class BrandsController < FrontController
  inherit_resources

  actions :index, :show

  def index
    add_breadcrumb(I18n.t('brands'), [:brands])
    index!
  end

  def show
    add_breadcrumb(I18n.t('brands'), [:brands])
    add_breadcrumb(resource.title, resource)

    @products = resource.products.published.
      includes(characteristics_products: :characteristic).
      paginate(page: params[:page], per_page: Settings.pagination.products)

    show!
  end

  private

  def collection
    @brands ||= Brand.published.with_published_products
  end
end

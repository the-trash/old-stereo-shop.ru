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
    show!
  end
end

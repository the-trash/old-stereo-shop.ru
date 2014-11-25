class StoresController < FrontController
  inherit_resources

  actions :show

  def show
    add_breadcrumb(resource.title, resource)
    show!
  end
end

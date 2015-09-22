module AdminApp
  class ProductsController < BaseController
    def index
      # TODO integrate with backbone.paginator
      @products = Product.paginate page: params[:page], per_page: Settings.admin.pagination.products
      gon.rabl template: 'engines/admin_app/app/views/admin_app/products/index.json', as: :products
    end
  end
end

class YandexMarketListsController < ActionController::Base
  http_basic_authenticate_with name: "admin", password: "qwerty"

  def index
    @products = Product.max2min(:created_at).simple_sort(params).paginate(page: params[:page], per_page: params[:per_page])
    render layout: 'yandex_market_lists'
  end

  def switch
    product_id = params[:yandex_market_list_id]
    checked    = params[:yandex]

    product = Product.find(product_id)
    product.update_attribute(:add_to_yandex_market, checked)

    render json: { product_id: product_id, checked: checked }
  end

  def export; end
end

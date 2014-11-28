class CartsController < FrontController
  before_filter :alien_cart

  def show
  end

  def update
  end

  private

  def alien_cart
    if @cart.session_token != session[:cart_token] || params[:id].to_i != @cart.id
      redirect_to [:root], flash: { error: I18n.t('alien_cart') }
    end
  end
end

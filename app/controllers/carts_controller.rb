class CartsController < FrontController
  before_filter :alien_cart

  def show
    render @cart.empty_cart? ? :empty : :show
  end

  def update
  end

  def destroy
    @cart.line_items.destroy_all
    redirect_to [:root], flash: :success
  end

  private

  def alien_cart
    redirect_to [:root], flash: { error: I18n.t('alien_cart') } if alien_cart?
  end

  def alien_cart?
    @cart.session_token != session[:cart_token] || params[:id].to_i != @cart.id
  end
end

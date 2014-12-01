class CartsController < FrontController
  before_filter :alien_cart
  before_action :empty_cart, only: :show

  def show
  end

  def update
  end

  def destroy
    @cart.destroy
    redirect_to [:root], flash: :success
  end

  private

  def alien_cart
    if @cart.session_token != session[:cart_token] || params[:id].to_i != @cart.id
      redirect_to [:root], flash: { error: I18n.t('alien_cart') }
    end
  end

  def empty_cart
    render :empty if @cart.line_items.empty?
  end
end

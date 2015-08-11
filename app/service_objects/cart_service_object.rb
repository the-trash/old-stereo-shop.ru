class CartServiceObject < Struct.new :current_user, :session, :params
  delegate :cart, to: :current_user, prefix: true

  def current_cart
    if current_user
      raise ActiveRecord::RecordNotFound unless current_user_cart
      assign_token_to_session current_user_cart.session_token
      current_user_cart
    else
      if params[:cart_token]
        cart_by_params
      else
        cart_by_token! session[:cart_token]
      end
    end
  rescue ActiveRecord::RecordNotFound
    assign_token_to_session token
    generate_cart
  end

  private

  def generate_cart
    Cart.create! session_token: token, user: current_user
  end

  def token
    @token ||= SecureRandom.urlsafe_base64(nil, false)
  end

  def assign_token_to_session token
    session[:cart_token] = token
  end

  def cart_by_token! token
    cart_with_line_items.find_by! session_token: token
  end

  def cart_by_token token
    cart_with_line_items.find_by session_token: token
  end

  def cart_with_line_items
    @cart_with_line_items ||= Cart.includes(line_items: :product)
  end

  def cart_by_params
    cart = cart_by_token params[:cart_token]

    if cart
      assign_token_to_session params[:cart_token]
      cart
    else
      Cart.new session_token: params[:cart_token].gsub(/[@{}\[\]()\'\"]/, '')
    end
  end
end

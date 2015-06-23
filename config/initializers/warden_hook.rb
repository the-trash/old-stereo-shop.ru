Warden::Manager.after_authentication do |user, auth, opts|
  session = auth.env['rack.session']

  # assign current session cart to user
  if session[:cart_token].present? && user.class.name != 'AdminUser'
    cart = Cart.find_by session_token: session[:cart_token]

    ActiveRecord::Base.transaction do
      user.cart.destroy if user.cart && user.cart.id != cart.id # remove old user cart
      cart.update_column :user_id, user.id

      user.reload
    end if cart
  end
end

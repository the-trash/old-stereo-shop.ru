class FrontController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_variables, :store_location

  add_breadcrumb '', :root_path

  def after_sign_in_path_for(resource)
    session[:user] = {
      product_ids: []
    }
    session[:previous_url] || super
  end

  def after_sign_out_path_for(resource)
    session[:user] = nil
    session[:previous_url] || super
  end

  protected

  def set_variables
    @front_presenter = FrontPresenter.new current_user, params
    @settings ||= $settings
    @cart = current_cart
  end

  def breadcrumbs_with_ancestors(obj, resource = nil)
    obj.ancestors.each do |parent_obj|
      add_breadcrumb parent_obj.title, parent_obj
    end

    add_breadcrumb obj.title, obj
    add_breadcrumb resource.title, resource if resource.present?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit \
        :city_id, :index, :address, :birthday,
        :phone, :email, :password, :password_confirmation,
        :full_name
    end
  end

  private

  def user_not_authorized
    redirect_to [:root], flash: { error: I18n.t('controllers.front.user_not_authorized') }
  end

  def current_cart
    if user_signed_in?
      cart = current_user.cart
      raise ActiveRecord::RecordNotFound unless cart
      session[:cart_token] = cart.session_token

      cart
    else
      if params[:cart_token]
        cart = Cart.includes(line_items: :product).find_by(session_token: params[:cart_token])

        if cart
          session[:cart_token] = params[:cart_token]
          cart
        else
          Cart.new(session_token: params[:cart_token].gsub(/[@{}\[\]()\'\"]/, ''))
        end
      else
        Cart.includes(line_items: :product).find_by!(session_token: session[:cart_token])
      end
    end
  rescue ActiveRecord::RecordNotFound
    token = SecureRandom.urlsafe_base64(nil, false)
    cart  = Cart.create!({ session_token: token, user: current_user })

    session[:cart_token] = token unless user_signed_in?

    cart
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end
end

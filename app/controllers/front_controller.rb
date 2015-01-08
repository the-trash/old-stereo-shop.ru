class FrontController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_variables

  add_breadcrumb '', :root_path

  def after_sign_in_path_for(resource)
    session[:user] = {
      product_ids: []
    }
    super
  end

  def after_sign_out_path_for(resource)
    session[:user] = nil
    super
  end

  protected

  def set_variables
    @meta = {
      seo_title: 'Стерео шоп',
      keywords: 'Ключевики',
      seo_description: 'Описание'
    }

    @settings ||= $settings

    # TODO: add cache
    @product_categories = ProductCategory.includes(:photos).for_front.arrange(order: :position)
    @news = PostCategory.find_by(title: I18n.t('news'))
    @useful_information = PostCategory.find_by(title: I18n.t('useful_information'))

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
end

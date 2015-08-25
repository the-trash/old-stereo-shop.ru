class MakeOrderInOneClickForm < Struct.new :current_user, :params
  include ActiveModel::Validations

  validate :params_correct

  delegate :email, :index, :address, :full_name, to: :current_user
  delegate :notify_about_one_click, to: :order

  def save
    if valid?
      persist! unless order_exist?
      true
    else
      false
    end
  end

  def self.permitted_params
    [:phone, :product_id]
  end

  def order
    @order ||= existed_order || generate_order
  end

  private

  def params_correct
    errors.add :product, I18n.t('product_id_should_present') unless params[:product_id].present?
    errors.add :phone, I18n.t('phone_should_present') unless phone.present?
  end

  def persist!
    ActiveRecord::Base.transaction do
      line_item
      notify_about_one_click
    end
  end

  def cart
    @cart ||= Cart.create \
      session_token: SecureRandom.urlsafe_base64(nil, false),
      user: current_user
  end

  def line_item
    cart.line_items.create product_id: params[:product_id], order: order
  end

  def generate_order
     if current_user
       current_user.orders.create build_attributes.merge(user_attributes)
     else
       Order.create cart: cart, phone: phone
     end
  end

  def phone
    @phone ||= Sanitize.fragment(params[:phone])
  end

  def order_exist?
    existed_order
  end

  def existed_order
    @existed_order ||= Order.where(user: current_user, phone: phone).first
  end

  def build_attributes
    { cart: cart, phone: phone }
  end

  def user_attributes
    {
      email: email,
      post_index: index,
      address: address,
      user_name: full_name
    }
  end
end

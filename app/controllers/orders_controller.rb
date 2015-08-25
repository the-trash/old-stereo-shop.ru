class OrdersController < FrontController
  respond_to :json, only: :in_one_click
  inherit_resources

  actions :create, :update, :show
  custom_actions  resource: [:delivery, :authenticate, :payment, :complete],
    collection: [:success_complete]

  before_filter :check_access_to_order, except: [:create, :success_complete, :show, :in_one_click]
  before_filter :check_access_to_show_order, only: :show

  def create
    create! do |success, failure|
      success.html do
        resource.cart_line_items.update_all(order_id: resource.id)
        redirect_to [:delivery, resource]
      end
      failure.html do
        redirect_to :back, flash: { error: resource_errors }
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        if Order.steps.keys.include? next_step
          redirect_to([next_step, resource])
        else
          redirect_to :back, flash: :error
        end
      end
      failure.html do
        redirect_to :back, flash: { error: resource_errors }
      end
    end
  end

  def complete
    if resource.make_complete!
      redirect_to [:success_complete, :orders]
    else
      redirect_to :back, flash: { error: resource_errors }
    end
  end

  def in_one_click
    form = MakeOrderInOneClickForm.new current_user, one_click_permitted_params
    form.save

    if form.valid?
      @order = form.order
      respond_with @order
    else
      # TODO add behavior for handling errors
      # hi five director :)
      render nothing: true
    end
  end

  private

  def build_resource
    @order ||= @cart.build_order
  end

  def build_resource_params
    if Order.steps.keys.include? order_step
      [
        params.require(:order)
          .permit(self.send("#{order_step}_permitted_params"))
          .merge(user_id: current_user.try(:id))
      ]
    else
      []
    end
  end

  def base_permitted_params
    %i(step)
  end

  def delivery_permitted_params
    base_permitted_params + %i(delivery)
  end

  def authentification_permitted_params
    base_permitted_params + %i(user_name phone city_id address post_index email)
  end

  def payment_permitted_params
    base_permitted_params + %i(payment file organization_name inn kpp)
  end

  def order_step
    params[:order][:step]
  end

  def next_step
    params[:order][:next_step]
  end

  def check_access_to_order
    if user_signed_in?
      authorize resource, :update?
    else
      raise_pundit_exception
    end
  end

  def check_access_to_show_order
    if user_signed_in?
      authorize resource, :show?
    else
      # TODO resolve problem with validation cart
      # raise_pundit_exception
    end
  end

  def raise_pundit_exception
    raise Pundit::NotAuthorizedError unless resource.cart == @cart
  end

  def resource_errors
    resource.errors.full_messages.join("\r\n")
  end

  def one_click_permitted_params
    params.require(:order).permit(*MakeOrderInOneClickForm.permitted_params)
  end
end

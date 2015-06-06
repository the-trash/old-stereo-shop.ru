class OrdersController < FrontController
  inherit_resources

  actions :create, :update
  custom_actions  resource: [:delivery, :authenticate, :payment]

  def create
    create! do |success, failure|
      success.html do
        resource.cart_line_items.update_all(order_id: resource.id)
        redirect_to [:delivery, resource]
      end
      failure.html do
        redirect_to :back, flash: { error: resource.errors.full_messages.join("\r\n") }
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
        redirect_to :back, flash: { error: resource.errors.full_messages.join("\r\n") }
      end
    end
  end

  def complete
    if resource.make_complete!
      redirect_to [:success_complete, :orders]
    else
      redirect_to :back, flash: { error: resource.errors.full_messages.join("\r\n") }
    end
  end

  def success_complete
    @order_page = Page.find_by(slug: 'order-complete')
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
    base_permitted_params + %i(user_name phone city_id address post_index)
  end

  def payment_permitted_params
    %i(payment file organization_name inn kpp)
  end

  def order_step
    params[:order][:step]
  end

  def next_step
    params[:order][:next_step]
  end
end

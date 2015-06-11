class OrderPolicy < Struct.new(:current_user, :order)
  def update?
    order.cart == current_user.cart
  end

  def show?
    current_user && current_user.order_ids.include?(order.id)
  end
end

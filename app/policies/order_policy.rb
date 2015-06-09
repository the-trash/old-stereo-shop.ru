class OrderPolicy < Struct.new(:current_user, :order)
  def update?
    order.cart == current_user.cart
  end
end

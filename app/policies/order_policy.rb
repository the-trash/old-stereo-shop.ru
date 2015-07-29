class OrderPolicy < Struct.new(:current_user, :order)
  delegate :order_ids, to: :current_user
  delegate :approved?, to: :order

  def update?
    order.cart == current_user.cart
  end

  def show?
    current_user && has_order? && approved?
  end

  private

  def has_order?
    order_ids.include? order.id
  end
end

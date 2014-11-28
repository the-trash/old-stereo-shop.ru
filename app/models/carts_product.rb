class CartsProduct < ActiveRecord::Base
  before_save :recalculate_total_amount, if: :quantity_changed?
  before_save :recalculate_products_count_for_cart, if: :count_changed?

  belongs_to :cart
  belongs_to :product

  validates :product, presence: true

  def calculated_total_amount
    product.price_with_discount * count
  end

  private

  def recalculate_total_amount
    self.total_amount = calculated_total_amount
  end

  def recalculate_products_count_for_cart
    cart.send(:recalculate_products_count)
  end
end

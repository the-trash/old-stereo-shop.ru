# == Schema Information
#
# Table name: line_items
#
#  id                    :integer          not null, primary key
#  cart_id               :integer
#  product_id            :integer
#  order_id              :integer
#  quantity              :integer          default(1)
#  current_product_price :decimal(10, 2)   default(0.0), not null
#
# Indexes
#
#  index_line_items_on_cart_id                 (cart_id)
#  index_line_items_on_cart_id_and_product_id  (cart_id,product_id) UNIQUE
#  index_line_items_on_order_id                (order_id)
#  index_line_items_on_product_id              (product_id)
#

class LineItem < ActiveRecord::Base
  scope :broken_position, -> { where(cart_id: nil, order_id: nil) }

  belongs_to :cart
  belongs_to :product
  belongs_to :order

  has_many :related_products, through: :product
  has_many :similar_products, through: :product

  validates :product, presence: true

  delegate :title, to: :product, prefix: true
  delegate :price_with_discount, :photos, :in_stock, to: :product

  alias_method :in_stock?, :in_stock

  def calculated_total_amount
    price_with_discount * quantity
  end

  def update_current_product_price
    update_attributes current_product_price: price_with_discount
  end
end

# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  cart_id    :integer
#  product_id :integer
#  order_id   :integer
#  quantity   :integer          default(1)
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

  has_many :related_products, through: :product
  has_many :similar_products, through: :product

  validates :product, presence: true

  delegate :price_with_discount, :photos, :title, to: :product, prefix: true

  def calculated_total_amount
    product_price_with_discount * quantity
  end
end

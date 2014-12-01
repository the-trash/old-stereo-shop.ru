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

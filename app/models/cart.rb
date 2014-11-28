class Cart < ActiveRecord::Base
  scope :old_cart, -> { where(updated_at: 14.days.ago) }

  has_many :carts_products, dependent: :nullify,
    after_add: [:recalculate_products_count, :recalculate_total_amount],
    after_remove: [:recalculate_products_count, :recalculate_total_amount]

  has_many :products, through: :carts_products

  belongs_to :user

  validates :session_token, presence: true

  private

  def recalculate_products_count(carts_product = nil)
    update_column(:products_count, carts_products.sum(:quantity))
  end

  def recalculate_total_amount(carts_product = nil)
    update_column(:total_amount, carts_products.to_a.sum(&:total_amount))
  end
end

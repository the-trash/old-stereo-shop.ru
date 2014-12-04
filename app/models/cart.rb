class Cart < ActiveRecord::Base
  scope :old_cart, -> { where(updated_at: 14.days.ago) }

  has_many :line_items, -> { order('id DESC') }, dependent: :nullify

  has_many :products, through: :line_items

  belongs_to :user

  validates :session_token, presence: true

  def add_product(product_id)
    current_line = line_items.find_by('line_items.product_id = ?', product_id)

    if current_line
      current_line.quantity += 1
    else
      current_line = line_items.build(product_id: product_id)
    end

    current_line
  end

  def total_amount
    line_items.to_a.sum(&:calculated_total_amount)
  end

  def total_quantity
    line_items.sum(:quantity)
  end
end

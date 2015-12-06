# == Schema Information
#
# Table name: carts
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  session_token :string           not null
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_carts_on_session_token  (session_token)
#  index_carts_on_user_id        (user_id)
#

class Cart < ActiveRecord::Base
  scope :old_carts, -> { where("#{table_name}.updated_at < ?", 14.days.ago) }
  scope :without_orders, -> {
    joins("LEFT JOIN orders ON #{table_name}.id = orders.cart_id")
    .where(orders: { id: nil })
  }

  has_many :line_items, -> { order('id DESC') }, dependent: :nullify
  has_many :products, through: :line_items

  has_one :order, dependent: :nullify

  belongs_to :user

  validates :session_token, presence: true

  delegate :step, to: :order, prefix: true

  def add_product(product_id)
    current_line = line_items.find_by('line_items.product_id = ?', product_id)

    if current_line
      current_line.increment!(:quantity)
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

  def empty_cart?
    line_items.empty?
  end
end

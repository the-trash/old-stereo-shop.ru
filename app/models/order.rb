# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  cart_id       :integer
#  city_id       :integer
#  state         :string(255)
#  step          :integer          default(0)
#  delivery      :integer          default(0)
#  payment       :integer          default(0)
#  post_index    :string(255)
#  user_name     :string(255)
#  phone         :string(255)
#  address       :text
#  cashless_info :hstore
#  file          :string(255)
#  total_amount  :decimal(10, 2)   default(0.0), not null
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_orders_on_cart_id  (cart_id)
#  index_orders_on_city_id  (city_id)
#  index_orders_on_user_id  (user_id)
#

class Order < ActiveRecord::Base
  include StateMachineHelper

  DELIVERIES = %w(courier point_of_delivery mail)
  PAYMENTS   = %w(payment_system receive cashless)
  EVENTS_MAP = {
    created: :make_complete,
    approved: :approve,
    paid: :paid_up,
    sent: :forward,
    arrived: :arrive
  }

  enum step: %i(delivery authentification payment complete)
  enum delivery: DELIVERIES
  enum payment: PAYMENTS

  scope :desc_ordered, -> { order id: :desc }

  has_many :line_items, -> { order(id: :desc) }, dependent: :nullify

  has_one :payment_transaction, dependent: :destroy, foreign_key: 'order_number'

  belongs_to :cart
  belongs_to :user
  belongs_to :city

  validates :delivery, inclusion: { in: DELIVERIES }
  validates :payment, inclusion: { in: PAYMENTS }
  validates :user_name, :phone, :city, :address, :post_index, presence: true, if: [:authentification?, :started?]
  # TODO fix me, you should check validation in spec
  validates :file, :inn, :kpp, :organization_name, presence: true, if: [:payment?, :cashless?]
  validate :not_cash_payment, if: [:payment?, :mail?, :receive?]

  delegate :total_amount, :line_items, to: :cart, prefix: true
  delegate :region, :region_title, to: :city
  delegate :title, to: :city, prefix: true

  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: :all_blank

  hstore_accessor :cashless_info,
    organization_name: :string,
    inn: :string,
    kpp: :string

  mount_uploader :file, FileUploader

  state_machine :state, initial: :started do
    state :started
    state :created
    state :approved
    state :paid
    state :sent
    state :arrived

    event :make_complete do
      transition started: :created
    end

    event :approve do
      transition any => :approved
    end

    event :paid_up do
      transition any => :paid
    end

    event :forward do
      transition any => :sent
    end

    event :arrive do
      transition any => :arrived
    end

    # TODO notify user if user exists
    before_transition started: :created, do: :make_order_completed
    after_transition started: :created, do: :notify_admins
    after_transition started: :created, do: :notify_user

    after_transition any => :approved, do: :notify_user
    after_transition any => :sent, do: :notify_user
    after_transition any => :arrived, do: :notify_user

    after_transition any => :paid, do: :notify_admins
  end

  def email
    user ? user.email : 'empty-user@empty-email.ru'
  end

  private

  def make_order_completed
    transaction do
      complete!
      update_column :total_amount, cart_total_amount
      set_current_products_price_to_line_items
      assing_line_items_to_order
    end
  end

  def assing_line_items_to_order
    cart_line_items.update_all \
      cart_id: nil,
      order_id: id
  end

  def set_current_products_price_to_line_items
    cart_line_items.map(&:update_current_product_price)
  end

  def notify_admins
    OrderMailer.delay.notify_admins self
  end

  def notify_user
    OrderMailer.delay.notify_user self
  end

  def not_cash_payment
    errors.add :payment
  end
end

# == Schema Information
#
# Table name: products
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  sku                     :string(255)
#  slug                    :string(255)
#  description             :text
#  state                   :integer          default(1)
#  price                   :decimal(10, 2)   default(0.0), not null
#  discount                :integer          default(0), not null
#  admin_user_id           :integer
#  brand_id                :integer
#  product_category_id     :integer
#  meta                    :hstore
#  created_at              :datetime
#  updated_at              :datetime
#  position                :integer          default(0)
#  score_weight            :integer          default(5)
#  average_score           :integer          default(0)
#  reviews_count           :integer          default(0)
#  published_reviews_count :integer          default(0)
#  removed_reviews_count   :integer          default(0)
#  moderated_reviews_count :integer          default(0)
#  in_stock                :boolean          default(TRUE)
#  euro_price              :decimal(10, 2)   default(0.0), not null
#  euro_rate               :decimal(10, 2)   default(0.0), not null
#  draft_reviews_count     :integer          default(0)
#  properties              :hstore
#
# Indexes
#
#  index_products_on_admin_user_id        (admin_user_id)
#  index_products_on_brand_id             (brand_id)
#  index_products_on_position             (position)
#  index_products_on_product_category_id  (product_category_id)
#  index_products_on_slug                 (slug)
#  index_products_on_state                (state)
#

class Product < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable, Ratable

  HOWSORT = %w(popular new_products price_reduction price_increase)
  ALLOWED_ATTRIBUTES = %i(title description price discount)

  scope :with_discount, -> { where('discount > 0') }
  scope :popular, -> { order(average_score: :desc) }
  scope :new_products, -> { order(created_at: :desc) }
  scope :price_reduction, -> { order_by_price('DESC') }
  scope :price_increase, -> { order_by_price('ASC') }
  scope :order_by_price, -> (how_order) {
    order("SUM(price - (price * discount)/100) #{ how_order }").
    group("#{ table_name }.id")
  }
  scope :sort_by, -> (how_sort) { send(:"#{ how_sort }") if self.need_sort?(how_sort) }
  scope :by_brand, -> (brand_id) { joins(:brand).where(brands: { id: brand_id }) }
  scope :on_hand, -> { where(in_stock: true) }
  scope :out_of_stock, -> { where(in_stock: false) }
  scope :by_q, -> (q) { where("#{ table_name }.title ILIKE :text", text: "%#{ q }%") }
  scope :with_euro_price, -> { where('euro_price > 0') }
  scope :has_in_stores, -> {
    joins(:products_stores).group('products.id').having('SUM(products_stores.count) > 0')
  }

  acts_as_list

  after_create :increment_product_category_cache_counters
  after_destroy :decrement_product_category_cache_counters

  before_save :recalculate_product_category_cache_counters, if: :state_changed?
  before_save :ensure_not_referenced_by_any_line_items, if: :state_changed?
  before_save :recalculate_price_for_the_euro, if: :need_recalculate_price?
  before_save :generate_sku, unless: :sku?

  %i(admin_user brand).each do |m|
    belongs_to m
  end

  belongs_to :product_category, counter_cache: true

  has_many :characteristics_products, dependent: :destroy
  has_many :characteristics, through: :characteristics_products

  has_many :products_stores, dependent: :destroy
  has_many :stores, -> { order(position: :desc) }, through: :products_stores

  has_many :wishes, dependent: :destroy

  has_many :line_items
  has_many :carts, through: :line_items

  has_many :additional_options, dependent: :destroy,
    class_name: 'Product::AdditionalOption'
  alias :product_additional_options :additional_options

  has_many :additional_options_values, through: :additional_options,
    class_name: 'Product::AdditionalOptionsValue',
    source: :values

  has_many :reviews, dependent: :destroy, as: :recallable
  STATES.each_with_index do |st, i|
    has_many :"#{ st }_reviews",
      -> { where(state: i + 1) },
      class_name: 'Review',
      dependent: :destroy,
      as: :recallable
  end

  has_and_belongs_to_many :related_products,
    -> { uniq },
    class_name: 'Product',
    join_table: 'products_related_products',
    foreign_key: :product_id,
    association_foreign_key: :related_product_id

  has_and_belongs_to_many :similar_products,
    -> { uniq },
    class_name: 'Product',
    join_table: 'products_similar_products',
    foreign_key: :product_id,
    association_foreign_key: :similar_product_id

  validates :title, :description, :product_category_id, :brand_id, :weight, :price, presence: true

  delegate :title, to: :product_category, prefix: true

  accepts_nested_attributes_for :products_stores, :characteristics_products,
    :reviews, allow_destroy: true, reject_if: :all_blank

  hstore_accessor :properties,
    weight: :integer

  def price_with_discount(custom_discount = nil)
    price - (price * (custom_discount.nil? ? discount : custom_discount)) / 100
  end

  def new_price_with_discount(new_price)
    [new_price, (new_price - (new_price * discount) / 100)]
  end

  private

  def increment_product_category_cache_counters
    ProductCategory.increment_counter(:"#{ state }_products_count", product_category.id)
  end

  def decrement_product_category_cache_counters
    ProductCategory.decrement_counter(:"#{ state }_products_count", product_category.id)
  end

  def recalculate_product_category_cache_counters
    ProductCategory.decrement_counter(:"#{ state_was }_products_count", product_category.id)
    ProductCategory.increment_counter(:"#{ state }_products_count", product_category.id)
  end

  def ensure_not_referenced_by_any_line_items
    if line_items.any?
      errors.add(:base, I18n.t('product_in_cart'))
      return false
    else
      return true
    end
  end

  def need_recalculate_price?
    state_changed? && published? && euro_price > 0 && euro_rate > 0
  end

  def recalculate_price_for_the_euro
    self.price = euro_price * euro_rate
  end

  def self.need_sort?(how_sort)
    HOWSORT.include?(how_sort)
  end

  def generate_sku
    self.sku = SecureRandom.uuid
  end
end

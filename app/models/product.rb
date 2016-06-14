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
#  add_to_yandex_market    :boolean          default(TRUE)
#  fix_price               :boolean          default(FALSE)
#  short_desc              :text
#  elco_id                 :string           default("")
#  elco_state              :string           default("")
#  elco_errors             :text
#  elco_amount_home        :integer
#  elco_amount_msk         :integer
#  elco_updated_at         :datetime
#  elco_price              :decimal(10, 2)   default(0.0), not null
#  elco_markup             :decimal(8, 2)    default(0.0), not null
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
  include ::SimpleSort::Base
  include Friendable, Seoble, Statable, Photoable, Ratable

  HOWSORT = %w(popular new_products price_reduction price_increase)
  ALLOWED_ATTRIBUTES = %i(title description price discount)

  scope :with_discount, -> { where('discount > 0') }
  scope :with_price_larger_than_value, -> (value = 0) { where('price > :value', value: value) }
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
  scope :by_q, -> (q) { where("#{table_name}.title @@ :text OR #{table_name}.description @@ :text", text: q) }
  scope :with_euro_price, -> { where('euro_price > 0') }
  scope :has_in_stores, -> {
    joins(:products_stores).group("#{table_name}.id")
    .having('SUM(products_stores.count) > 0')
  }
  scope :for_yandex_market, -> { where(add_to_yandex_market: true) }
  scope :by_position, -> (direction = :asc) { order position: direction }
  scope :without_fix_price, -> { where(fix_price: false) }
  scope :by_category_ids, -> (ids) { where product_category_id: ids }
  scope :by_presence, -> { order in_stock: :desc }

  acts_as_list scope: :product_category

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
      -> { where(state: i) },
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
  delegate :title, to: :brand, prefix: true

  accepts_nested_attributes_for :products_stores, :characteristics_products,
    :reviews, allow_destroy: true, reject_if: :all_blank

  hstore_accessor :properties,
    weight: :integer

  def price_with_discount
    price - (price * discount) / 100
  end

  def total_elco_price
    (elco_price.to_f + (elco_price.to_f * elco_markup.to_f * 0.01)).to_i
  end

  private

  def ensure_not_referenced_by_any_line_items
    if line_items.any?
      errors.add(:base, I18n.t('product_in_cart'))
      false
    else
      true
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

  public

  # ELCO
  def get_elco_data!

    client = ::Savon.client do
      wsdl "https://ecom.elko.ru/xml/listener.asmx?WSDL"
      convert_request_keys_to :camelcase
    end

    msg = {
      username: ::ElcoImport::LOGIN,
      password: ::ElcoImport::PASSWORD,
      ELKOcode: elco_id,
      CategoryCode: '',
      VendorCode: ''
    }

    begin
      response = client.call(:catalog_product_list, message: msg)

      if response.xpath('//Response/Success').text == 'True'
        # vendor: response.xpath('//product/vendor').text
        elco_data = {
          id:     response.xpath('//product/id').text,
          name:   response.xpath('//product/name').text,
          price:  response.xpath('//product/price').text,
          spb:    response.xpath('//product/quantityInStock').text,
          msk:    response.xpath('//product/quantityInStock_MOS').text
        }

        in_stock = (elco_data[:spb].to_i > 0) || (elco_data[:msk].to_i > 0)
        puts in_stock ? "PRODUCT >>> IN STOCK" : "PRODUCT >>> NOT IN STOCK"

        update_columns({
          in_stock: in_stock,
          elco_state: :success,
          elco_amount_home: elco_data[:spb],
          elco_amount_msk:  elco_data[:msk],
          elco_price:       elco_data[:price],
          elco_updated_at:  Time.zone.now,
          elco_errors: ''
        })

        return [:success, elco_data]
      else
        elco_data = {
          id: msg[:ELKOcode],
          message: response.xpath('//Response/Message').text
        }

        update_columns({
          elco_state: :failed,
          elco_errors: elco_data.join
        })

        return [:error, elco_data]
      end
    rescue Exception => e
      elco_data = {
        elco_state: :failed,
        elco_errors: e.message,
        elco_updated_at: Time.zone.now
      }
      update_columns(elco_data)

      return [:error, elco_data]
    end
  end

end

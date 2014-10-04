class Product < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable, Ratable

  scope :without_ids, -> (ids) { where.not(id: ids) }

  acts_as_list

  %i(admin_user product_category brand).each do |m|
    belongs_to m
  end

  has_many :characteristics_products, dependent: :destroy
  has_many :characteristics, through: :characteristics_products

  has_many :products_stores, dependent: :destroy
  has_many :stores, -> { order(position: :desc) }, through: :products_stores

  has_and_belongs_to_many :related_products,
    -> { uniq },
    class_name: 'Product',
    join_table: 'products_related_products',
    foreign_key: :product_id,
    association_foreign_key: :related_product_id

  validates :title, :description, :product_category_id, :admin_user_id,
    :brand_id, presence: true

  delegate :title, to: :product_category, prefix: true

  accepts_nested_attributes_for :products_stores, :characteristics_products,
    :related_products, allow_destroy: true, reject_if: :all_blank

  def price_with_discount
    price - discount
  end

  def make_characteristics_tree
    chars_products = characteristics_products.index_by(&:characteristic_id)
    chars          = characteristics.group_by(&:characteristic_category_id)
    char_cats      = CharacteristicCategory.where(id: chars.keys).order(id: :asc)

    [].tap do |a|
      char_cats.each do |category|
        tmp = {
            category: category,
            characteristics: []
          }

        chars[category.id].each do |char|
          tmp[:characteristics] <<
            {
              characteristic: char,
              characteristic_value: chars_products[char.id]
            }
        end

        a << tmp
      end
    end
  end

  def make_stores
    prod_stores = products_stores.index_by(&:store_id)
    _stores     = Store.where(id: prod_stores.keys).order_by

    [].tap do |a|
      _stores.each do |store|
        a << {
          store: store,
          store_count: prod_stores[store.id]
        }
      end
    end
  end
end

class Product < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable, Ratable

  acts_as_list

  %i(admin_user product_category brand).each do |m|
    belongs_to m
  end

  has_many :characteristics_products, dependent: :destroy
  has_many :characteristics, through: :characteristics_products

  has_many :products_stores, dependent: :destroy
  has_many :stores, -> { order(position: :desc) }, through: :products_stores

  validates :title, :description, :product_category_id, :admin_user_id,
    :brand_id, presence: true

  delegate :title, to: :product_category, prefix: true

  accepts_nested_attributes_for :products_stores, :characteristics_products,
    allow_destroy: true, reject_if: :all_blank

  def price_with_discount
    price - discount
  end
end

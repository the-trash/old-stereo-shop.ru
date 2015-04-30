# == Schema Information
#
# Table name: brands
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  slug          :string(255)
#  description   :text
#  site_link     :string(255)
#  state         :integer          default(1)
#  admin_user_id :integer
#  meta          :hstore
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer          default(0)
#
# Indexes
#
#  index_brands_on_admin_user_id  (admin_user_id)
#  index_brands_on_position       (position)
#  index_brands_on_slug           (slug)
#  index_brands_on_state          (state)
#

class Brand < ActiveRecord::Base
  include Friendable, Seoble, Statable

  acts_as_list

  scope :with_published_products, -> {
    joins(:products).group('brands.id').
    where(products: { state: 1 }).
    having('count(products.brand_id) > 0')
  }
  scope :by_product_category, -> (product_category_id = nil) {
    joins(:products).group('brands.id').
    where(products: { product_category_id: product_category_id }) if product_category_id.present?
  }
  scope :order_by_position, -> (direction = :asc) { order(position: direction) }

  belongs_to :admin_user

  has_many :products, dependent: :destroy

  validates :title, :admin_user_id, presence: true
end

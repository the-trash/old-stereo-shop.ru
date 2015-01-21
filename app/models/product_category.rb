# == Schema Information
#
# Table name: product_categories
#
#  id                       :integer          not null, primary key
#  title                    :string(255)
#  slug                     :string(255)
#  description              :text
#  state                    :integer          default(1)
#  admin_user_id            :integer
#  meta                     :hstore
#  created_at               :datetime
#  updated_at               :datetime
#  position                 :integer          default(0)
#  ancestry                 :string(255)
#  depth                    :integer
#  published_products_count :integer          default(0)
#  removed_products_count   :integer          default(0)
#  products_count           :integer          default(0)
#  sale                     :boolean          default(FALSE)
#  sale_products_count      :integer          default(0)
#
# Indexes
#
#  index_product_categories_on_admin_user_id  (admin_user_id)
#  index_product_categories_on_ancestry       (ancestry)
#  index_product_categories_on_position       (position)
#  index_product_categories_on_slug           (slug)
#  index_product_categories_on_state          (state)
#

class ProductCategory < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  has_ancestry cache_depth: true, depth_cache_column: :depth

  scope :for_front, -> {
    joins(:products).published.
    where(products: { state: 1 }).
    group('product_categories.id')
  }

  belongs_to :admin_user

  has_many :products, dependent: :destroy
  %w(published removed moderated).each_with_index do |st, i|
    has_many :"#{ st }_products",
      -> { where(state: i + 1) },
      class_name: 'Product',
      dependent: :destroy
  end

  validates :title, :admin_user_id, presence: true

  def self.for_select
    all.map { |u| [u.title, u.id] } if connection.table_exists?(table_name)
  end
end

# == Schema Information
#
# Table name: products_stores
#
#  id         :integer          not null, primary key
#  product_id :integer
#  store_id   :integer
#  count      :integer          not null
#
# Indexes
#
#  composite_product_store              (product_id,store_id) UNIQUE
#  index_products_stores_on_product_id  (product_id)
#  index_products_stores_on_store_id    (store_id)
#

class ProductsStore < ActiveRecord::Base
  scope :by_store_ids, -> (store_ids) { where(store_id: store_ids) }

  belongs_to :product
  belongs_to :store

  validates :count, presence: true

  delegate :title, to: :store, prefix: true
end

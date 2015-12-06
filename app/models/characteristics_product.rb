# == Schema Information
#
# Table name: characteristics_products
#
#  id                :integer          not null, primary key
#  product_id        :integer
#  characteristic_id :integer
#  value             :string
#
# Indexes
#
#  composite_product_characteristic                     (product_id,characteristic_id) UNIQUE
#  index_characteristics_products_on_characteristic_id  (characteristic_id)
#  index_characteristics_products_on_product_id         (product_id)
#

class CharacteristicsProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :characteristic

  validates :value, presence: true

  delegate :characteristic_category_title, to: :characteristic, prefix: :characteristic
  delegate :title, :unit, to: :characteristic, prefix: true
end

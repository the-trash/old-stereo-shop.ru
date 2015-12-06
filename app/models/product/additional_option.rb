# == Schema Information
#
# Table name: product_additional_options
#
#  id          :integer          not null, primary key
#  title       :string
#  slug        :string
#  render_type :integer          default(0)
#  state       :integer          default(1)
#  product_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_product_additional_options_on_product_id            (product_id)
#  index_product_additional_options_on_product_id_and_state  (product_id,state)
#  index_product_additional_options_on_state                 (state)
#

class Product::AdditionalOption < ActiveRecord::Base
  include Friendable, Statable

  RENDER_TYPES = %i(select_style radio)

  enum render_type: RENDER_TYPES

  has_many :values,
    class_name: 'Product::AdditionalOptionsValue',
    inverse_of: :additional_option,
    dependent: :destroy,
    foreign_key: :product_additional_option_id

  has_many :product_attributes,
    through: :values,
    source: :new_values

  belongs_to :product

  validates :product, :title, presence: true

  accepts_nested_attributes_for :values, allow_destroy: true, reject_if: :all_blank
end

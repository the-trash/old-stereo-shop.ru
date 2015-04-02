# == Schema Information
#
# Table name: product_additional_options_values
#
#  id                           :integer          not null, primary key
#  product_additional_option_id :integer
#  value                        :string(255)
#  state                        :integer          default(1)
#
# Indexes
#
#  additional_options_id_index                       (product_additional_option_id)
#  index_product_additional_options_values_on_state  (state)
#

class Product::AdditionalOptionsValue < ActiveRecord::Base
  include Statable

  has_many :new_values, class_name: 'Product::AttributesValue',
    foreign_key: :additional_options_value_id,
    inverse_of: :value

  belongs_to :additional_option,
    class_name: 'Product::AdditionalOption',
    inverse_of: :values,
    foreign_key: :product_additional_option_id

  validates :additional_option, :value, presence: true

  accepts_nested_attributes_for :new_values, allow_destroy: true, reject_if: :all_blank

  delegate :photos, to: :additional_option
end

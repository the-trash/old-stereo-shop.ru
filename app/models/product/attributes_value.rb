# == Schema Information
#
# Table name: product_attributes_values
#
#  id                          :integer          not null, primary key
#  additional_options_value_id :integer
#  state                       :integer          default(1)
#  product_attribute           :integer
#  new_value                   :string(255)
#
# Indexes
#
#  additional_options_value_with_new_value               (additional_options_value_id)
#  index_product_attributes_values_on_product_attribute  (product_attribute)
#  index_product_attributes_values_on_state              (state)
#

class Product::AttributesValue < ActiveRecord::Base
  include Statable

  enum product_attribute: Product::ALLOWED_ATTRIBUTES

  self.product_attributes.each do |attr_name, i|
    scope :"with_#{ attr_name }", -> { where(product_attribute: i) }
  end

  belongs_to :value, class_name: 'Product::AdditionalOptionsValue',
    inverse_of: :new_values

  validates :new_value, presence: true

  def sanitize_new_value
    Sanitize.fragment(new_value, sanitize_config)
  end

  def sanitize_config
    Sanitize::Config.merge \
      Sanitize::Config::BASIC,
      elements: Sanitize::Config::BASIC[:elements] + ['img', 'div']
  end
end

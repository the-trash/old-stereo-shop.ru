# == Schema Information
#
# Table name: product_additional_options_values
#
#  id                           :integer          not null, primary key
#  product_additional_option_id :integer
#  value                        :string(255)
#
# Indexes
#
#  additional_options_id_index  (product_additional_option_id)
#

class Product::AdditionalOptionsValue < ActiveRecord::Base
  belongs_to :additional_option,
    class_name: 'Product::AdditionalOption',
    inverse_of: :values

  validates :additional_option, :value, presence: true
end

# == Schema Information
#
# Table name: characteristics
#
#  id                         :integer          not null, primary key
#  title                      :string(255)
#  position                   :integer          default(0)
#  characteristic_category_id :integer
#  unit                       :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#
# Indexes
#
#  characteristic_category_position                     (characteristic_category_id,position)
#  index_characteristics_on_characteristic_category_id  (characteristic_category_id)
#

class Characteristic < ActiveRecord::Base
  acts_as_list scope: :characteristic_category_id

  belongs_to :characteristic_category

  has_many :characteristics_products, dependent: :destroy
  has_many :products, through: :characteristics_products

  validates :title, :unit, :characteristic_category_id, presence: true

  delegate :title, to: :characteristic_category, prefix: true
end

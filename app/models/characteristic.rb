class Characteristic < ActiveRecord::Base
  acts_as_list scope: :characteristic_category_id

  belongs_to :characteristic_category

  validates :title, :unit, :characteristic_category_id, presence: true

  delegate :title, to: :characteristic_category, prefix: true
end

class CharacteristicsProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :characteristic

  validates :value, presence: true

  delegate :characteristic_category_title, to: :characteristic, prefix: :characteristic
  delegate :title, :unit, to: :characteristic, prefix: true
end

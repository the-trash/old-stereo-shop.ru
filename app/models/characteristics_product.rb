class CharacteristicsProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :characteristic

  validates :value, :product, :characteristic, presence: true

  delegate :characteristic_category_title, to: :characteristic, prefix: :characteristic
end

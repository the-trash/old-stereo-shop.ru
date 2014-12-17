class ProductsStore < ActiveRecord::Base
  belongs_to :product
  belongs_to :store

  validates :count, presence: true

  delegate :title, to: :store, prefix: true
end

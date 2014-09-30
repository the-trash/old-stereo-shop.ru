class ProductsStore < ActiveRecord::Base
  belongs_to :product
  belongs_to :store

  validates :product, :store, :count, presence: true

  delegate :title, to: :store, prefix: true
end

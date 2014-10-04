class Store < ActiveRecord::Base
  include Statable, Friendable

  acts_as_list

  scope :products_are, -> { where(happens: true) }
  scope :order_by, -> (field = 'id', how_to_sort = 'asc') {
    order("#{ field } #{ how_to_sort }")
  }

  belongs_to :admin_user

  has_many :products_stores, dependent: :destroy
  has_many :products, through: :products_stores

  validates :title, :admin_user, presence: true
end

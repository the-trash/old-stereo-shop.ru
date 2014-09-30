class Store < ActiveRecord::Base
  include Statable, Friendable

  acts_as_list

  scope :all_happens, -> { where(happens: true) }

  belongs_to :admin_user

  has_many :products_stores, dependent: :destroy
  has_many :products, through: :products_stores

  validates :title, :admin_user, presence: true
end

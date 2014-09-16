class ProductCategory < ActiveRecord::Base
  include Friendable, Seoble

  belongs_to :admin_user

  has_many :products, dependent: :destroy

  validates :title, :admin_user_id, presence: true
end

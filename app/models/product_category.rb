class ProductCategory < ActiveRecord::Base
  include Friendable

  belongs_to :admin_user

  has_many :products, dependent: :destroy
end

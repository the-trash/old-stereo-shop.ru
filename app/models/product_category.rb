class ProductCategory < ActiveRecord::Base
  include Friendable, Seoble

  belongs_to :admin_user

  has_many :products, dependent: :destroy
end

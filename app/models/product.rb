class Product < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  acts_as_list

  %i(admin_user product_category brand).each do |m|
    belongs_to m
  end

  validates :title, :description, :product_category_id, :admin_user_id,
    :brand_id, presence: true

  delegate :title, to: :product_category, prefix: true
end

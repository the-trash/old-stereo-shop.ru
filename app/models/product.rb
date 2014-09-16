class Product < ActiveRecord::Base
  include Friendable, Seoble

  %i(admin_user product_category brand).each do |m|
    belongs_to m
  end
end

class Product < ActiveRecord::Base
  include Friendable

  %i(admin_user product_category).each do |m|
    belongs_to m
  end
end

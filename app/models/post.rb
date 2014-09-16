class Post < ActiveRecord::Base
  include Friendable, Seoble

  %i(admin_user post_category).each do |m|
    belongs_to m
  end

  validates :title, :admin_user_id, :post_category_id, presence: true
end
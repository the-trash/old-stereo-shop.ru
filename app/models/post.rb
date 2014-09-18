class Post < ActiveRecord::Base
  include Friendable, Seoble, Statable

  acts_as_list

  %i(admin_user post_category).each do |m|
    belongs_to m
  end

  validates :title, :admin_user_id, :post_category_id, presence: true
end

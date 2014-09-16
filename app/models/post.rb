class Post < ActiveRecord::Base
  include Friendable, Seoble

  %i(admin_user post_category).each do |m|
    belongs_to m
  end
end

class Post < ActiveRecord::Base
  include Friendable

  %i(admin_user post_category).each do |m|
    belongs_to m
  end
end

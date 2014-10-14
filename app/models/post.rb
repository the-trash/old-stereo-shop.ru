class Post < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  acts_as_list

  scope :by_category, -> (category_title) {
    includes(:post_category).where(post_categories: { title: category_title })
  }

  scope :for_front, -> (category_title, limit = 10) {
    by_category(category_title).order(id: :desc).limit(limit)
  }

  %i(admin_user post_category).each do |m|
    belongs_to m
  end

  validates :title, :admin_user_id, :post_category_id, presence: true
end

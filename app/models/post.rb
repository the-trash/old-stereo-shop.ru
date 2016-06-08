# == Schema Information
#
# Table name: posts
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  slug             :string(255)
#  description      :text
#  full_text        :text
#  state            :integer          default(1)
#  admin_user_id    :integer
#  post_category_id :integer
#  meta             :hstore
#  created_at       :datetime
#  updated_at       :datetime
#  position         :integer          default(0)
#
# Indexes
#
#  index_posts_on_admin_user_id     (admin_user_id)
#  index_posts_on_position          (position)
#  index_posts_on_post_category_id  (post_category_id)
#  index_posts_on_slug              (slug)
#  index_posts_on_state             (state)
#

class Post < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  acts_as_list

  scope :by_category, -> (category_title) {
    includes(:post_category).where(post_categories: { title: category_title })
  }
  scope :order_desc, -> { order created_at: :desc }

  %i(admin_user post_category).each do |m|
    belongs_to m
  end

  validates :title, :admin_user_id, :post_category_id, presence: true

  delegate :title, to: :post_category, prefix: true
end

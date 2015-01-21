# == Schema Information
#
# Table name: post_categories
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  slug          :string(255)
#  description   :text
#  state         :integer          default(1)
#  admin_user_id :integer
#  meta          :hstore
#  created_at    :datetime
#  updated_at    :datetime
#  position      :integer          default(0)
#  ancestry      :string(255)
#  depth         :integer
#
# Indexes
#
#  index_post_categories_on_admin_user_id  (admin_user_id)
#  index_post_categories_on_ancestry       (ancestry)
#  index_post_categories_on_position       (position)
#  index_post_categories_on_slug           (slug)
#  index_post_categories_on_state          (state)
#

class PostCategory < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  has_ancestry cache_depth: true, depth_cache_column: :depth

  belongs_to :admin_user

  %i(posts newletters).each do |r|
    has_many r, dependent: :destroy
  end

  validates :title, :admin_user_id, presence: true

  def self.for_select
    all.map{ |pc| [pc.title, pc.id] } if connection.table_exists?(table_name)
  end
end

# == Schema Information
#
# Table name: newletters
#
#  id                :integer          not null, primary key
#  title             :string
#  description       :text
#  admin_user_id     :integer
#  post_category_id  :integer
#  last_delivery     :datetime
#  state             :integer          default(1)
#  subscription_type :integer          default(0)
#  settings          :hstore
#  created_at        :datetime
#  updated_at        :datetime
#
# Indexes
#
#  index_newletters_on_admin_user_id      (admin_user_id)
#  index_newletters_on_post_category_id   (post_category_id)
#  index_newletters_on_state              (state)
#  index_newletters_on_subscription_type  (subscription_type)
#

class Newletter < ActiveRecord::Base
  include Statable

  SUBSCRIPTION_TYPES = %i(news bonus product_delivered deals)

  enum subscription_type: SUBSCRIPTION_TYPES

  self.subscription_types.each do |st, i|
    scope :"#{ st }", -> { where(subscription_type: i) }
  end

  before_save :set_posts_count, if: :calculate_posts_count?

  %i(admin_user post_category).each do |r|
    belongs_to r
  end

  validates :title, :admin_user, :post_category, presence: true

  delegate :title, to: :post_category, prefix: true

  hstore_accessor :settings,
    posts_count: :integer,
    only_new_posts: :boolean

  private

  def set_posts_count
    self.posts_count = rand(5..10)
  end

  def calculate_posts_count?
    !posts_count || posts_count.zero?
  end
end

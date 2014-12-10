class Newletter < ActiveRecord::Base
  include Statable

  SUBSCRIPTION_TYPES = %i(news bonus product_delivered deals)

  enum subscription_type: SUBSCRIPTION_TYPES

  self.subscription_types.each do |st, i|
    scope :"#{ st }", -> { where(subscription_type: i) }
  end

  before_save :set_posts_count

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
    self.posts_count = rand(5..10) if posts_count.to_i == 0
  end
end

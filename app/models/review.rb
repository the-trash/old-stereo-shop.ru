class Review < ActiveRecord::Base
  include Statable

  after_create :increment_recallable_cache_counters
  after_destroy :decrement_recallable_cache_counters
  before_save :recalculate_product_category_cache_counters, if: :state_changed?

  belongs_to :recallable, polymorphic: true, counter_cache: true

  belongs_to :user, counter_cache: true
  belongs_to :rating, dependent: :destroy

  validates :recallable, :body, :user_id, :rating_id, presence: true

  private

  def increment_recallable_cache_counters
    Product.increment_counter(:"#{ state }_reviews_count", recallable_id) if recallable_type == 'Product'
  end

  def decrement_recallable_cache_counters
    Product.decrement_counter(:"#{ state }_reviews_count", recallable_id) if recallable_type == 'Product'
  end

  def recalculate_product_category_cache_counters
    if recallable_type == 'Product'
      Product.decrement_counter(:"#{ state_was }_reviews_count", recallable_id)
      Product.increment_counter(:"#{ state }_reviews_count", recallable_id)
    end
  end
end

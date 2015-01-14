class Review < ActiveRecord::Base
  include Statable

  scope :related, -> (limit = Settings.product.reviews_count) {
    where(updated_at: [7.days.ago..DateTime.now] ).order(id: :desc).limit(limit)
  }

  after_create :increment_recallable_cache_counters, if: :need_recalculate?
  after_destroy :decrement_recallable_cache_counters, if: :need_recalculate?

  before_save :recalculate_product_category_cache_counters, if: :need_recalculate_after_state_changed?

  belongs_to :recallable, polymorphic: true, counter_cache: true

  belongs_to :user, counter_cache: true
  belongs_to :rating, dependent: :destroy

  validates :recallable, :body, :user_id, :rating_id, presence: true

  delegate :score, to: :rating, prefix: true

  private

  def need_recalculate?
    recallable_type_product? && !draft?
  end

  def recallable_type_product?
    recallable_type == 'Product'
  end

  def need_recalculate_after_state_changed?
    state_changed? && recallable_type_product? && !draft?
  end

  def increment_recallable_cache_counters
    Product.increment_counter(:"#{ state }_reviews_count", recallable_id)
  end

  def decrement_recallable_cache_counters
    Product.decrement_counter(:"#{ state }_reviews_count", recallable_id)
  end

  def recalculate_product_category_cache_counters
    Product.decrement_counter(:"#{ state_was }_reviews_count", recallable_id)
    Product.increment_counter(:"#{ state }_reviews_count", recallable_id)
  end
end

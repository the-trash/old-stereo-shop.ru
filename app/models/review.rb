# == Schema Information
#
# Table name: reviews
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  rating_id       :integer
#  body            :text
#  pluses          :string(255)
#  cons            :string(255)
#  recallable_id   :integer
#  recallable_type :string(255)
#  state           :integer          default(3)
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_reviews_on_rating_id                                      (rating_id)
#  index_reviews_on_recallable_id_and_recallable_type              (recallable_id,recallable_type)
#  index_reviews_on_recallable_id_and_recallable_type_and_state    (recallable_id,recallable_type,state)
#  index_reviews_on_user_id                                        (user_id)
#  index_reviews_on_user_id_and_recallable_id_and_recallable_type  (user_id,recallable_id,recallable_type) UNIQUE
#

class Review < ActiveRecord::Base
  include Statable

  scope :related, -> (limit = Settings.product.reviews_count) {
    where(updated_at: [7.days.ago..DateTime.now] ).order(id: :desc).limit(limit)
  }

  after_create :increment_recallable_cache_counters, if: :need_recalculate?
  after_destroy :decrement_recallable_cache_counters, if: :need_recalculate?

  before_save :recalculate_product_cache_counters, if: [:state_changed?, :need_recalculate?, :wasnot_draft?]

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

  def wasnot_draft?
    state_was != 'draft'
  end

  def increment_recallable_cache_counters
    Product.increment_counter(:"#{ state }_reviews_count", recallable_id)
  end

  def decrement_recallable_cache_counters
    Product.decrement_counter(:"#{ state }_reviews_count", recallable_id)
  end

  def recalculate_product_cache_counters
    Product.decrement_counter(:"#{ state_was }_reviews_count", recallable_id)
    Product.increment_counter(:"#{ state }_reviews_count", recallable_id)
  end
end

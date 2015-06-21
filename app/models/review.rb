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

  belongs_to :recallable, polymorphic: true, counter_cache: true

  belongs_to :user, counter_cache: true
  belongs_to :rating, dependent: :destroy

  validates :recallable, :body, :user_id, :rating_id, presence: true

  delegate :score, to: :rating, prefix: true
end

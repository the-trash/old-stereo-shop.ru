class Review < ActiveRecord::Base
  include Statable

  belongs_to :recallable, polymorphic: true, counter_cache: true

  belongs_to :user, counter_cache: true
  belongs_to :rating, dependent: :destroy

  validates :recallable, :body, :user_id, :rating_id, presence: true
end

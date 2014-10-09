class Review < ActiveRecord::Base
  include Statable

  belongs_to :recallable, polymorphic: true, counter_cache: true
  %w(published removed moderated).each do |st|
    belongs_to :recallable,
      polymorphic: true,
      counter_cache: :"#{ st }_reviews_count",
      inverse_of: :"#{ st }_reviews"
  end

  belongs_to :user, counter_cache: true
  belongs_to :rating, dependent: :destroy

  validates :recallable, :body, :user_id, :rating_id, presence: true
end

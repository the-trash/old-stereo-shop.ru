module Ratable
  extend ActiveSupport::Concern

  included do
    has_many :ratings,
      as: :votable,
      dependent: :destroy,
      after_add: :recalculate_average_score

    before_save :remove_ratings_and_recalculate_score, if: :score_weight_changed?

    def generate_vote(user, score)
      ratings.create(user: user, score: score)
    end

    private

    def recalculate_average_score(rating = nil)
      update_column(:average_score, ratings.average(:score).to_i)
    end

    def remove_ratings_and_recalculate_score
      transaction do
        ratings.for_removing(score_weight).delete_all
        recalculate_average_score
      end
    end
  end
end

class ReviewForm < BaseForm
  attr_accessor :body, :pluses, :cons, :rating_score, :user_name, :leave_anonymous_review,
    :recallable_id

  validates :body, :rating_score, :recallable_id, presence: true
  validates :rating_score, numericality: { greater_than: 0 }

  delegate :correct_user_name, :anonymous_user, :user, to: :model

  def self.permitted_params
    %i(
      body pluses cons rating_score user_name user
      leave_anonymous_review recallable_id
    )
  end

  private

  def persist!
    model.transaction do
      product.reviews.create! \
        user: user,
        body: Sanitize.fragment(body),
        cons: Sanitize.fragment(cons),
        pluses: Sanitize.fragment(pluses),
        user_name: review_user_name,
        rating: rating
    end
  end

  def review_user_name
    if leave_anonymous_review.present?
      anonymous_user
    else
      Sanitize.fragment(user_name).presence || correct_user_name
    end
  end

  def rating
    @rating ||= product.generate_vote user, rating_score
  end

  def product
    @product ||= Product.find recallable_id
  end
end

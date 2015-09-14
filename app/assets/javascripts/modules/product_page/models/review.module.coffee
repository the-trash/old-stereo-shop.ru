class Review extends Backbone.RailsModel
  url: Routes.reviews_path
  className: 'Review'

  defaults:
    recallable_id: gon.product.id

  save_attributes: [
    'body'
    'pluses'
    'cons'
    'rating_score'
    'user_name'
    'leave_anonymous_review'
    'recallable_id'
  ]

module.exports = Review

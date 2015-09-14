LayoutMakeOrderInOneClick = require './views/make_order_in_one_click/layout'
RatableWithReviewLayout = require './views/ratable_with_reviews/ratable_with_reviews'
NewReview = require './views/new_review/layout'

Order = require './models/order'
Review = require './models/review'

Application = new Marionette.Application

Application.addRegions
  orderInOneClickRegion: '.l-make-order-in-one-click'
  ratableWithReviews: '.l-product-ratable-with-reviews'
  newReview: '.l-new-review'

Application.addInitializer ->
  @orderInOneClickRegion.show new LayoutMakeOrderInOneClick model: new Order()
  # TODO make ratable in share component
  @ratableWithReviews.show new RatableWithReviewLayout()
  @newReview.show new NewReview model: new Review()

module.exports = Application

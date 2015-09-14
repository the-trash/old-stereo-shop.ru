class RatableWithReviews extends Marionette.ItemView
  template: 'product_page/ratable_with_reviews/ratable_with_reviews'
  className: 'b-product-ratable-with-reviews'

  ui:
    review : '.b-reviews-count a'

  events:
    'click @ui.review' : 'showReviewsTab'

  showReviewsTab: ->
    @ui.review.tab('show')

  onRender: ->
    @showReviewsTab() if @needShowTab()

  needShowTab: ->
    window.location.hash == @ui.review.attr 'href'

module.exports = RatableWithReviews

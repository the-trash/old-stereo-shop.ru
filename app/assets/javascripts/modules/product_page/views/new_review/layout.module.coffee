Form = require './form'
SuccessMessage = require './success_message'

class Layout extends Marionette.LayoutView
  template: 'product_page/new_review/layout'
  className: 'b-new-review'

  regions:
    newReviewFrom:           '.l-new-review-form'
    newReviewSuccessMessage: '.l-new-review-success-message'

  ui:
    newReviewBtn: '.b-new-review-btn'

  events:
    'click @ui.newReviewBtn' : 'hideNewReviewBtn showNewReviewBody'

  childEvents:
    'show:new-review-btn'  : 'showNewReviewBtn'
    'show:success-message' : 'showSuccessMessage'

  hideNewReviewBtn: ->
    @ui.newReviewBtn.hide()

  showNewReviewBtn: ->
    @ui.newReviewBtn.show()

  showNewReviewBody: ->
    @newReviewFrom.show new Form({@model})

  showSuccessMessage: ->
    @newReviewSuccessMessage.show new SuccessMessage()

module.exports = Layout

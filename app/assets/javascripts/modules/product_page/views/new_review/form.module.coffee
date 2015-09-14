class Form extends Marionette.ItemView
  template: 'product_page/new_review/form'
  tagName: 'form'
  className: 'b-new-review-form'

  ui:
    rating:    '.b-ratable'
    cancelBtn: '.b-new-review-from-cancel-btn'
    submitBtn: '.b-new-review-from-submit-btn'

  events:
    'click @ui.cancelBtn' : 'hideForm'
    'click @ui.submitBtn' : 'preventDefault sendForm'

  onRender: ->
    @bindDatalinks()
    @initRatable()

  hideForm: ->
    @triggerMethod 'show:new-review-btn'
    @remove()

  sendForm: ->
    @model.save {},
      success: @showSuccessMessage
      error: @showErrors

  initRatable: ->
    @ui.rating.raty
      path: '/images/raty'
      click: @setRatingScore

  setRatingScore: (score) =>
    @model.set rating_score: score

  showSuccessMessage: =>
    @triggerMethod 'show:success-message'
    @remove()

  # TODO add common behaviors for showing errors and success messages
  showErrors: =>

module.exports = Form

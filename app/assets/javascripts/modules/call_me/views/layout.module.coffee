callMeForm = require './call_me_form'
successMessage = require './success_message'

class CallMeLayout extends Marionette.LayoutView
  template: 'call_me/layout'
  className: 'b-call-me'

  regions:
    modalContent: '.l-call-me-modal-content'

  ui:
    callMeBtn: '.b-call-me-button'

  events:
    'click @ui.callMeBtn' : 'renderForm'

  childEvents:
    'render:success-message' : 'renderSuccessMessage'

  renderForm: ->
    @modalContent.show new callMeForm()

  # TODO add common behaviors for showing errors and success messages
  renderSuccessMessage: ->
    @modalContent.show new successMessage()

module.exports = CallMeLayout

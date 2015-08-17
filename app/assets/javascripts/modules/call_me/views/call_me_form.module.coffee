callMeModel = require '../models/call_me'

class CallMeForm extends Marionette.ItemView
  template: 'call_me/form'
  model: new callMeModel()

  ui:
    sendFormBtn : '.b-call-me-send-btn'
    callMeForm  : '.l-call-me-from'
    phoneInput  : '.b-call-me-phone-input'

  events:
    'click @ui.sendFormBtn' : 'sendFrom'

  triggerRenderSuccessMessage: ->
    @.triggerMethod 'render:success-message'

  formValid: ->
    @ui.phoneInput.val().length > 0

  sendFrom: ->
    if @formValid()
      @syncFormData()
      @triggerRenderSuccessMessage()

  syncFormData: ->
    @model.save
      feedback:
        phone: @ui.phoneInput.val()

module.exports = CallMeForm

callMeModel = require '../models/call_me'

class CallMeForm extends Marionette.ItemView
  template: 'call_me/form'
  model: new callMeModel()
  className: 'modal-content'

  ui:
    sendFormBtn : '.b-call-me-send-btn'
    callMeForm  : '.l-call-me-from'
    phoneInput  : '.b-call-me-phone-input'
    formGroup   : '.form-group'

  events:
    'click @ui.sendFormBtn' : 'validateForm sendFrom'

  onRender: ->
    @ui.callMeForm.validator()
    @bindDatalinks()

  triggerRenderSuccessMessage: ->
    @.triggerMethod 'render:success-message'

  validateForm: (event) ->
    @ui.callMeForm.validator('validate')
    event.stopImmediatePropagation() unless @formValid()

  formValid: ->
    !@ui.formGroup.hasClass('has-error') && @ui.phoneInput.val().length > 0

  sendFrom: ->
    @syncFormData()
    @triggerRenderSuccessMessage()

  syncFormData: ->
    @model.save()

module.exports = CallMeForm

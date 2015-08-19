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
    'click @ui.sendFormBtn' : 'sendFrom'

  onRender: ->
    @ui.callMeForm.validator()

  triggerRenderSuccessMessage: ->
    @.triggerMethod 'render:success-message'

  validateForm: ->
    @ui.callMeForm.validator('validate')

  formValid: ->
    !@ui.formGroup.hasClass('has-error') && @ui.phoneInput.val().length > 0

  sendFrom: ->
    @validateForm()

    if @formValid()
      @syncFormData()
      @triggerRenderSuccessMessage()

  syncFormData: ->
    @model.save
      feedback:
        phone: @ui.phoneInput.val()

module.exports = CallMeForm

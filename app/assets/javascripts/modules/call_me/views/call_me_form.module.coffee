class CallMeForm extends Marionette.ItemView
  template: 'call_me/form'
  className: 'modal-content'

  ui:
    sendFormBtn    : '.b-call-me-send-btn'
    phoneInput     : '.b-call-me-phone-input'
    formGroupPhone : '.l-call-me-form-phone-input'

  events:
    'keypress @ui.phoneInput' : 'suppressEnterKeypress validateForm sendFrom'
    'click @ui.sendFormBtn'   : 'validateForm sendFrom'

  validationPattern: /^\+\d\s\(\d{3}\)\s\d{3}\-\d{4}$/

  onRender: ->
    @initPhoneValidator()

  validateForm: (event) ->
    if !@formValid()
      @ui.formGroupPhone.addClass 'has-error'
      event.stopImmediatePropagation()

  formValid: ->
    @validationPattern.test @ui.phoneInput.val()

  sendFrom: ->
    @model.save phone: @ui.phoneInput.val()
    @triggerMethod 'render:success-message'

  initPhoneValidator: ->
    @ui.phoneInput.bfhphone @ui.phoneInput.data()

module.exports = CallMeForm

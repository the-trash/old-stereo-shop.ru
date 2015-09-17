class MakeOrderForm extends Marionette.ItemView
  template: 'product_page/order_in_one_click/form'
  className: 'b-make-order-in-one-click-form form-inline'
  tagName: 'form'

  ui:
    sendFormBtn    : '.b-make-order-in-one-click-send-btn'
    formGroupPhone : '.l-order-in-one-click-form-phone-input'
    phoneInput     : '.b-make-order-in-one-click-phone-input'

  events:
    'keypress @ui.phoneInput' : 'suppressEnterKeypress validateForm sendFrom'
    'click @ui.sendFormBtn'   : 'validateForm sendFrom'

  validationPattern: /^\+\d\s\(\d{3}\)\s\d{3}\-\d{4}$/

  # TODO add errors messages and show them on front
  onRender: ->
    @bindDatalinks()
    @initPhoneValidator()

  formValid: ->
    @validationPattern.test @ui.phoneInput.val()

  validateForm: (event) ->
    if !@formValid()
      @ui.formGroupPhone.addClass 'has-error'
      event.stopImmediatePropagation()

  sendFrom: ->
    @model.save phone: @ui.phoneInput.val()
    @triggerMethod 'render:success-message'

  initPhoneValidator: ->
    @ui.phoneInput.bfhphone @ui.phoneInput.data()

module.exports = MakeOrderForm

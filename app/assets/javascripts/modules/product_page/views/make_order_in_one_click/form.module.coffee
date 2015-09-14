class MakeOrderForm extends Marionette.ItemView
  template: 'product_page/order_in_one_click/form'
  className: 'b-make-order-in-one-click-form form-inline'
  tagName: 'form'
  attributes:
    'data-toggle': 'validator'
    role: 'form'

  ui:
    sendFormBtn : '.b-make-order-in-one-click-send-btn'
    formGroup   : '.form-group'
    phoneInput  : '.b-make-order-in-one-click-phone-input'

  events:
    'click @ui.sendFormBtn' : 'validateForm sendFrom'

  # TODO add errors messages and show them on front
  onRender: ->
    @$el.validator()
    @bindDatalinks()

  formValid: ->
    !@ui.formGroup.hasClass('has-error') && @ui.phoneInput.val().length > 0

  triggerRenderSuccessMessage: ->
    @.triggerMethod 'render:success-message'

  validateForm: (event) ->
    @$el.validator('validate')
    event.stopImmediatePropagation() unless @formValid()

  sendFrom: ->
    @syncFormData()
    @triggerRenderSuccessMessage()

  syncFormData: ->
    @model.save()

module.exports = MakeOrderForm

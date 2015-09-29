Base = require './base'

class SelectType extends Base
  template: 'product_page/additional_options/types/select'
  className: 'b-product-additional-options-select-type'

  ui:
    select: '.b-additional-option-select'

  events:
    'change @ui.select' : 'triggerDefaults beforeFetch fetch'

  isCheckedDefault: ->
    @ui.select.val() == '0'

  beforeFetch: (e) ->
    e.stopImmediatePropagation() if @isCheckedDefault()

  fetch: ->
    @model.fetch
      data:
        value: @ui.select.val()

module.exports = SelectType

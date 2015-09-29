Base = require './base'

class RadioType extends Base
  template: 'product_page/additional_options/types/radio'
  className: 'b-product-additional-options-radio-type'

  ui:
    clearBtn: '.b-additional-options-clear'
    radiosLayout: '.l-additional-options-radios'

  events:
    'click label:not(.b-additional-options-clear)' : 'hasActive toggleActiveClass triggerDefaults fetch'
    'click @ui.clearBtn' : 'toggleActiveClass triggerDefaults'

  hasActive: (e) ->
    e.stopImmediatePropagation() if $(e.target.control).hasClass 'active'

  toggleActiveClass: (e) ->
    @removeAllActiveClasses()
    $(e.target.control).addClass 'active'

  removeAllActiveClasses: ->
    _.each @ui.radiosLayout.find('input.active'), (item) ->
      $(item).removeClass 'active'

  fetch: (e) ->
    @model.fetch
      data:
        value: $(e.target.control).val()

module.exports = RadioType

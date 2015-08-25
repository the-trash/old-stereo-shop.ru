MakeOrderForm = require './form'
successMessage = require './success_message'

class Layout extends Marionette.LayoutView
  template: 'order_in_one_click/layout'
  className: 'b-make-order-in-one-click'

  regions:
    mainRegion: '.l-make-order-in-one-click-body'

  childEvents:
    'render:success-message' : 'renderSuccessMessage'

  onRender: ->
    @mainRegion.show new MakeOrderForm({@model})

  renderSuccessMessage: ->
    @mainRegion.show new successMessage()

module.exports = Layout

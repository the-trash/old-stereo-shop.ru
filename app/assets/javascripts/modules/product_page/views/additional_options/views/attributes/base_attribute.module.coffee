class BaseAttribute extends Marionette.ItemView
  initialize: ({@item}) ->

  templateHelpers: ->
    item: @item

module.exports = BaseAttribute

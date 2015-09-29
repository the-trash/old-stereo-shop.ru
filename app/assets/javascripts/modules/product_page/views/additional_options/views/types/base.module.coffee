class Base extends Marionette.ItemView
  modelEvents:
    'sync' : 'triggerRenderNewAttributes'

  triggerDefaults: ->
    @triggerMethod 'render:defaults'

  triggerRenderNewAttributes: ->
    @triggerMethod 'render:attributes', @model

  templateHelpers: ->
    publishedOptions: @model.get('options_values').publishedValues()

module.exports = Base

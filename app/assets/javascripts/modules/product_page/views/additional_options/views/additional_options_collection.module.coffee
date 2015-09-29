RadioType = require './types/radio_type'
SelectType = require './types/select_type'

class AdditionalOptionsCollection extends Marionette.CollectionView
  getChildView: (item) ->
    switch item.get 'render_type'
      when 'radio' then RadioType
      when 'select_style' then SelectType
      else throw "Unknown type '#{item.get('render_type')}'"

module.exports = AdditionalOptionsCollection

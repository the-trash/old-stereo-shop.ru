AttributesTypeCasting =
  typeCastedAttributes: {}

  typeCastAttributes: ->
    for name, type of @typeCastedAttributes
      @set name, @toType(type, @get name)

  toType: (type, value) ->
    switch type
      when 'boolean'
        Util.valueToBoolean value
      when 'numeric'
        parseInt(value) || 0
      else
        value

module.exports = AttributesTypeCasting
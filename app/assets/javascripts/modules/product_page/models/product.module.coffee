AdditionalOption = require './additional_option'

class Product extends Backbone.RailsModel
  hasMany:
    additional_options: AdditionalOption.Collection

  formattedPrice: (price) ->
    intPrice = parseInt price

    if intPrice > 0 and price % intPrice == 0
      intPrice
    else
      price

module.exports = Product

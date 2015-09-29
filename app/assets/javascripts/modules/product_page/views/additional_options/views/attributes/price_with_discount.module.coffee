class PriceWithDiscount extends Marionette.ItemView
  template: 'product_page/additional_options/attributes/price_with_discount'
  className: 'b-additional-options-new-price-with-discount'

  initialize: ({@newPrice, @newDiscount}) ->

  hasDiscount: ->
    @newDiscount > 0

  withDiscount: ->
    @newPrice - (@newPrice * @newDiscount) / 100

  priceWithDiscount: ->
    @model.formattedPrice @withDiscount()

  formattedNewPrice: ->
    @model.formattedPrice @newPrice

  templateHelpers: ->
    newPrice: @formattedNewPrice()
    hasDiscount: @hasDiscount()
    priceWithDiscount: @priceWithDiscount()

module.exports = PriceWithDiscount

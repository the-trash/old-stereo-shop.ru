AdditionalOption = {}
OptionsValue = {}

class OptionsValue.Model extends Backbone.Model
class OptionsValue.Collection extends Backbone.Collection
  model: OptionsValue.Model

  publishedValues: ->
    @.where state: 'published'

class AdditionalOption.Model extends Backbone.RailsModel
  className: 'AdditionalOption'

  hasMany:
    options_values: OptionsValue.Collection

  url: ->
    Routes.product_additional_option_path gon.product.id, @id

  priceWithDiscount: ->
    _.reject @get('product_attributes'), (item) ->
      item.type not in ['price', 'discount']

  price: ->
    newPrice = _.findWhere @priceWithDiscount(), type: 'price'
    newPrice.value unless _.isEmpty newPrice

  discount: ->
    newDiscount = _.findWhere @priceWithDiscount(), type: 'discount'
    newDiscount.value unless _.isEmpty newDiscount

  hasPhotos: ->
    _.any @get('photos')

  photos: ->
    @get('photos')

  defaultPhoto: ->
    _.findWhere(@photos(), default: true) || _.first(@photos())

class AdditionalOption.Collection extends Backbone.Collection
  model: AdditionalOption.Model

module.exports = AdditionalOption

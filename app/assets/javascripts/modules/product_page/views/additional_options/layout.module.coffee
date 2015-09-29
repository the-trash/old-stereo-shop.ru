AdditionalOptions = require './views/additional_options_collection'
Title = require './views/attributes/title'
Description = require './views/attributes/description'
PriceWithDiscount = require './views/attributes/price_with_discount'
Gallery = require './views/gallery'

class Layout extends Marionette.LayoutView
  template: 'product_page/additional_options/layout'
  className: 'b-additional-options'

  regions:
    additionalOptions: '.l-product-additional-options'

  childEvents:
    'render:defaults' : 'showDefaults'
    'render:attributes' : 'showNewAttributes'

  initialize: ({@regions}) ->

  onRender: ->
    @additionalOptions.show new AdditionalOptions
      collection: @model.get 'additional_options'

  showDefaults: ->
    @regions.defaultTitle.$el.show()
    @regions.defaultGallery.$el.show()
    @regions.defaultDescription.$el.show()
    @regions.defaultPriceWithDiscount.$el.show()
    @hideNewAttributesRegions()

  hideNewAttributesRegions: ->
    @regions.customizedTitle.$el.hide()
    @regions.customizedGallery.$el.hide()
    @regions.customizedDescription.$el.hide()
    @regions.customizedPriceWithDiscount.$el.hide()

  showNewAttributes: (view, additionalOption) ->
    _.each additionalOption.get('product_attributes'), (item) =>
      switch item.type
        when 'title' then @showNewTitle item
        when 'description' then @showNewDescription item

    @showPriceWithDiscount additionalOption unless _.isEmpty additionalOption.priceWithDiscount()
    @showPhotos additionalOption if additionalOption.hasPhotos()

  showNewTitle: (item) ->
    @regions.defaultTitle.$el.hide()
    @regions.customizedTitle.$el.show()
    @regions.customizedTitle.show new Title({item})

  showNewDescription: (item) ->
    @regions.defaultDescription.$el.hide()
    @regions.customizedDescription.$el.show()
    @regions.customizedDescription.show new Description({item})

  showPriceWithDiscount: (additionalOption) ->
    @regions.defaultPriceWithDiscount.$el.hide()
    @regions.customizedPriceWithDiscount.$el.show()
    @regions.customizedPriceWithDiscount.show new PriceWithDiscount
      model: @model
      newPrice: (additionalOption.price() || @model.get('price'))
      newDiscount: (additionalOption.discount() || @model.get('discount'))

  showPhotos: (additionalOption) ->
    @regions.defaultGallery.$el.hide()
    @regions.customizedGallery.$el.show()
    @regions.customizedGallery.show new Gallery model: additionalOption

module.exports = Layout

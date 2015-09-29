class Gallery extends Marionette.ItemView
  template: 'product_page/additional_options/gallery'
  className: 'l-additional-options-new-gallery'

  templateHelpers: ->
    defaultPhoto: @model.defaultPhoto()
    photos: @model.photos()

module.exports = Gallery

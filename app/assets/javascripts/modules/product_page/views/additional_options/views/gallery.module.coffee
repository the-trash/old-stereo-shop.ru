class Gallery extends Marionette.ItemView
  template: 'product_page/additional_options/gallery'
  className: 'l-additional-options-new-gallery'

  ui:
    thumbnail: '.e-thumb-image'
    mainImage: '.e-main-image'

  events:
    'click @ui.thumbnail' : 'changePhoto'

  changePhoto: (e) ->
    @ui.mainImage.css 'background-image', "url(#{ $(e.currentTarget).data('big-img-url') })"

  templateHelpers: ->
    defaultPhoto: @model.defaultPhoto()
    photos: @model.photos()

module.exports = Gallery

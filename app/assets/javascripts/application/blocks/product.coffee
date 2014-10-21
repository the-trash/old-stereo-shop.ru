class ProductShowPage
  constructor: ->
    @initGallery()

  initGallery: ->
    imagesBlock = $('.b-product-images')
    if imagesBlock.length
      imagesBlock.on 'click', '.e-thumb-image', (e) ->
        $('.e-main-image').css('background-image', "url(#{ $(this).data('big-img-url') })")

@ProductShowPage = ProductShowPage

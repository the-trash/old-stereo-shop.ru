# TODO override me on Marionette.js
class ProductShowPage
  constructor: ->
    @initGallery()
    @moreReview()

  initGallery: ->
    imagesBlock = $('.b-product-images')
    if imagesBlock.length
      imagesBlock.on 'click', '.e-thumb-image', (e) ->
        $('.e-main-image').css('background-image', "url(#{ $(this).data('big-img-url') })")

  moreReview: ->
    $('body').on 'click', '.more-review', (e) ->
      _this        = $(this)
      dataMore     = parseInt _this.attr('data-more')
      reviewsCount = parseInt _this.data('count')
      e.preventDefault()

      $.ajax
        url: _this.attr('href')
        type: 'GET'
        data:
          more: reviewsCount + dataMore
        success: (data) ->
          if data.length == 1
            _this.remove()
            false

          $(data).insertBefore(_this)
          _this.attr 'data-more', reviewsCount + dataMore

@ProductShowPage = ProductShowPage

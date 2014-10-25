class ProductShowPage
  constructor: ->
    @initGallery()
    @newReview()

  initGallery: ->
    imagesBlock = $('.b-product-images')
    if imagesBlock.length
      imagesBlock.on 'click', '.e-thumb-image', (e) ->
        $('.e-main-image').css('background-image', "url(#{ $(this).data('big-img-url') })")

  newReview: ->
    $('body').on 'click', '.new-review-link', (e) ->
      _this = $(this)
      e.preventDefault()

      $.ajax
        url: _this.attr('href')
        type: 'GET'
        success: (data) ->
          $(data).insertAfter(_this)
          _this.hide()
          new Ratable($('.new-review'))

          $('.new-review-form').on 'click', '.cancel-btn', (e) ->
            e.preventDefault()

            $('.new-review-link').show()
            $('.b-review-new').remove()

@ProductShowPage = ProductShowPage

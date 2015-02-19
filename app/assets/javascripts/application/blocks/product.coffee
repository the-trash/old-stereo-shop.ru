class ProductShowPage
  constructor: ->
    @initGallery()
    @newReview()
    @moreReview()
    @clickOnRadio()
    @changeAdditionalOptionsSelect()

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

  clickOnRadio: ->
    $('body').on 'click', '.b-additional-option .radio-label', (e) ->
      form = $(this).closest('form')
      $('.additional-options-radio').val form.find('input#' + $(this).attr('for')).val()
      form.submit()

  changeAdditionalOptionsSelect: ->
    $('body').on 'change', '.b-additional-option select', (e) ->
      $(this).closest('form').submit()

@ProductShowPage = ProductShowPage

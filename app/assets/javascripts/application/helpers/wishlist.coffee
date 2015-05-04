# TODO: add errors or use marionette

class Wishlist
  constructor: (@el) ->
    @product = $(@el).closest('.b-single-product')
    @sendAjax()

  sendAjax: () ->
    $.ajax
      url: $(@el).attr('href')
      data: ''
      type: $(@el).data('method')
      dataType: 'json'
      success: (data) =>
        if @product.hasClass('wishlist')
          @product.fadeOut().remove()
        else
          $(@el).closest('li').children('i').remove()
          $(@el).replaceWith data.link

@Wishlist = Wishlist

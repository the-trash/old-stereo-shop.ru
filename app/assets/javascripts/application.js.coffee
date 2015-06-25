###
  = require jquery
  = require jquery_ujs
  = require jquery.gray.min
  = require select2
  = require select2_locale_ru
  = require_directory ./application/helpers
  = require_directory ./application/blocks
  = require jquery.raty
  = require jquery-ui/tabs
  = require bootstrap-3/dropdown
  = require_self
###

$(document).ready ->
  $('body').find('.ratable').each ->
    new Ratable(this)

  if $('.b-product').length
    new ProductShowPage()

  if $('.b-product-category').length || $('.b-search').length
    new ProductCategoryShowPage()

  if $('.b-cart').length
    new Cart()

  if $('.get-cities').length
    new CitiesSelect
      el: $('.get-cities')

  $('body').find('.tabs').each ->
    $(this).tabs
      activate: (event, ui) ->
        ui.oldTab.removeClass('active')
        ui.newTab.addClass('active')

  $('body').on 'click', '.with-children > span.arrow', (e) ->
    if $(this).hasClass('down')
      $(this).next('.children').show()
      $(this).html('&#x25B2;').removeClass('down').addClass('up')
    else
      $(this).next('.children').hide()
      $(this).html('&#x25BC;').removeClass('up').addClass('down')

  $('body').on 'click', '#catalog > .btn', (e) ->
    e.preventDefault()
    $('.main-catalog').toggle()
    $(@).toggleClass('active')

  $('body').on 'click', '.e-additional-fields', (e) ->
    e.preventDefault()

    $('.b-additional-fields-for-sign-up').toggle()

    $(@).children('i').toggleClass('icon-arrow-bottom icon-arrow-top')

  $('body').on 'click', '.help-question', (e) ->
    e.preventDefault()

    $(@).closest('li').toggleClass('active')
    $(@).next('.description').toggle()

  $('body').on 'click', '.user-widget > .cart.with-good', (e) ->
    e.preventDefault()
    $('.user-widget-wrapper .line-items').toggle()
    $('.user-widget .you_watched').toggle()

  $('body').on 'click', 'a[data-role="add-to-wish"]', (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
    new Wishlist $(this)

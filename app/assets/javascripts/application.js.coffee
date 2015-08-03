###
  = require jquery/dist/jquery
  = require jquery-ujs/src/rails
  = require jquery.gray.min
  = require select2/select2
  = require select2/select2_locale_ru
  = require bootstrap-sass/assets/javascripts/bootstrap/dropdown
  = require bootstrap-sass/assets/javascripts/bootstrap/tab
  = require raty/lib/jquery.raty
  = require_directory ./application/helpers
  = require_directory ./application/blocks
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

  $('body').on 'click', "a[data-toggle='tab']", (e) ->
    e.preventDefault()
    $(this).tab 'show'

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

  $('.dropdown-toggle').dropdown()

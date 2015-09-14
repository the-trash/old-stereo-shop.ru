###
  = require commonjs/common
  = require jquery/dist/jquery
  = require jquery-ujs/src/rails

  = require underscore/underscore
  = require underscore.string/lib/underscore.string
  = require backbone/backbone
  = require backbone.babysitter/lib/backbone.babysitter
  = require backbone.wreqr/lib/backbone.wreqr
  = require marionette/lib/backbone.marionette
  = require backbone.modelbinder/Backbone.ModelBinder.min
  = require_tree ./lib/backbone

  = require gray/js/jquery.gray.min
  = require raty/lib/jquery.raty
  = require select2/select2
  = require select2/select2_locale_ru

  = require i18n

  = require hamlcoffee
  = require js-routes

  = require bootstrap-sass/assets/javascripts/bootstrap/dropdown
  = require bootstrap-sass/assets/javascripts/bootstrap/collapse
  = require bootstrap-sass/assets/javascripts/bootstrap/tab
  = require bootstrap-sass/assets/javascripts/bootstrap/modal

  = require bootstrap-validator/dist/validator.min

  = require_directory ./application/helpers
  = require_directory ./application/blocks

  = require_self

  = require modules/call_me/application.module
###

_.mixin(_.string.exports())

window.withElement = (selector, callback) ->
  callback selector if $(selector).length

$ ->
  $('body').find('.b-ratable').each ->
    new Ratable(this)

  withElement '.b-product', (selector) ->
    new ProductShowPage()

  withElement '.b-product-category, .b-search', (selector) ->
    new ProductCategoryShowPage()

  withElement '.b-cart', (selector) ->
    new Cart()

  withElement '.get-cities', (selector) ->
    new CitiesSelect
      el: $(selector)

  withElement '.l-call-me', (selector) ->
    callMeApplication = require 'modules/call_me/application'
    callMeApplication.start()

  $('body').on 'click', "a[data-toggle='tab']", (e) ->
    e.preventDefault()
    $(this).tab 'show'

  $('body').on 'click', '.e-additional-fields', (e) ->
    e.preventDefault()

    $('.b-additional-fields-for-sign-up').toggle()

    $(@).children('i').toggleClass('icon-arrow-bottom icon-arrow-top')

  $('body').on 'click', '.user-widget > .cart.with-good', (e) ->
    e.preventDefault()
    $('.user-widget-wrapper .line-items').toggle()
    $('.user-widget .you_watched').toggle()

  $('body').on 'click', 'a[data-role="add-to-wish"]', (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
    new Wishlist $(this)

  $('.dropdown-toggle').dropdown()

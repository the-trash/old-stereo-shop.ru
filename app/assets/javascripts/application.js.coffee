###
  = require jquery
  = require jquery_ujs
  = require jquery.gray.min
  = require_directory ./application/helpers
  = require_directory ./application/blocks
  = require jquery.raty
  = require jquery-ui/tabs
  = require_self
###

$(document).ready ->
  $('body').find('.ratable').each ->
    new Ratable(this)

  if ('.b-product').length
    new ProductShowPage()

  $('body').find('.tabs').each ->
    $(this).tabs()

  $('body').on 'click', '.with-children > span.arrow', (e) ->
    if $(this).hasClass('down')
      $(this).next('.children').show()
      $(this).html('&#x25B2;').removeClass('down').addClass('up')
    else
      $(this).next('.children').hide()
      $(this).html('&#x25BC;').removeClass('up').addClass('down')

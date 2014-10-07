###
  = require jquery
  = require jquery_ujs
  = require jquery.gray.min
  = require_directory ./application/helpers
  = require_directory ./application/blocks
  = require jquery.raty
  = require_self
###

$(document).ready ->
  $('body').find('.ratable').each ->
    $(@).raty
      click: (score, evt) ->
        $('#review_rating_score').val(score)

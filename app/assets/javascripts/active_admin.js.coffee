###
  = require active_admin/base
  = require select2
  = require select2_locale_ru
  = require_tree ./admin
  = require jquery.raty
###

$(document).ready ->
  $('body').find('select').each ->
    $(@).select2
      width: 'resolve'
      allowClear: true

  $('body').find('.ratable.read_only').each ->
    $(@).raty
      score: $(@).data('score')
      readOnly: true

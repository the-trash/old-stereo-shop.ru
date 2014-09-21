###
  = require active_admin/base
  = require active_admin/select2
  = require_tree ./admin
###

$(document).ready ->
  $('body').find('select').each ->
    $(@).select2
      width: 'resolve'

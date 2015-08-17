#= require_tree ./views
#= require_tree ../../templates/call_me
#= require_tree ./models

callMeLinkLayout = require './views/layout'

Application = new Marionette.Application

Application.addRegions
  mainRegion: '.l-call-me'

Application.addInitializer () ->
  @mainRegion.show new callMeLinkLayout()

module.exports = Application

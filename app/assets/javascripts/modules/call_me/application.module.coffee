#= require_tree ./views
#= require_tree ../../templates/call_me

callMeLink = require './views/call_me_link'

Application = new Marionette.Application

Application.addRegions
  mainRegion: '.l-call-me'

Application.addInitializer () ->
  @mainRegion.show new callMeLink()

module.exports = Application

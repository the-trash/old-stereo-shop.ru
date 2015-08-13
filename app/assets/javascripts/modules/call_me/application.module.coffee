#= require_tree ./views
#= require_tree ../../templates/call_me

Application = new Marionette.Application

Application.addRegions
  mainRegion: '.l-call-me'

Application.addInitializer () ->
  console.log @mainRegion

module.exports = Application

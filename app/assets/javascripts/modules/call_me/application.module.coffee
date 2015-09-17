#= require_tree ./views
#= require_tree ../../templates/call_me
#= require_tree ./models

callMeLinkLayout = require './views/layout'
callMeModel = require './models/call_me'

Application = new Marionette.Application

Application.addRegions
  mainRegion: '.l-call-me'

Application.addInitializer () ->
  @mainRegion.show new callMeLinkLayout model: new callMeModel()

module.exports = Application

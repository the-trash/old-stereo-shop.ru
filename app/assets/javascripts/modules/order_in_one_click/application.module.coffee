Layout = require './views/layout'

Order = require './models/order'

Application = new Marionette.Application

Application.addRegions
  mainRegion: '.l-make-order-in-one-click'

Application.addInitializer ->
  @mainRegion.show new Layout model: new Order()

module.exports = Application

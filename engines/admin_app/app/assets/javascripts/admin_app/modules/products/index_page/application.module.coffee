Application = new Marionette.Application

Product = require './models/product'
Layout  = require './views/layout'

Application.addRegions
  mainRegion: '.l-admin-app-products'

Application.addInitializer ->
  @mainRegion.show new Layout collection: new Product.Collection gon.products

module.exports = Application

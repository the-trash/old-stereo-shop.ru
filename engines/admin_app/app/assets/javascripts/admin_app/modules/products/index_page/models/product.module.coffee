Product = {}

class Product.Model extends Backbone.RailsModel
  className: 'Product'

  url: -> AdminAppRoutes.admin_app_product_path @id

class Product.Collection extends Backbone.Collection
  model: Product.Model

module.exports = Product

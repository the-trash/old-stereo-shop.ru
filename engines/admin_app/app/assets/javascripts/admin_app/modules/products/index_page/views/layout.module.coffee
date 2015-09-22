Product = require './product'

# TODO add EmptyView
class Layout extends Marionette.CompositeView
  template: 'admin_app/templates/products/index_page/layout'
  className: 'b-admin-app-products table table-hover table-bordered'
  tagName: 'table'
  childView: Product
  childViewContainer: '.l-admin-app-products-collection'

module.exports = Layout

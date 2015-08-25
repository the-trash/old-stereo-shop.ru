class Order extends Backbone.RailsModel
  url: Routes.in_one_click_orders_path
  className: 'Order'

  defaults:
    product_id: gon.product.id

  save_attributes: [
    'phone',
    'product_id'
  ]

module.exports = Order

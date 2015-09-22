# TODO add components for actions
class Product extends Marionette.LayoutView
  template: 'admin_app/templates/products/index_page/product'
  className: 'b-admin-app-product'
  tagName: 'tr'

  templateHelpers: ->
    showProductPath: AdminAppRoutes.product_path @model.id
    editProductCategoryPath: AdminAppRoutes.admin_app_edit_product_category_path @model.get('product_category_id')

module.exports = Product

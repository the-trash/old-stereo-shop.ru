ActiveAdmin.register Product do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 3

  actions :all, except: :show
  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :description, :state, :admin_user_id, :price, :discount,
    :product_category_id, :position, meta: [:keywords, :seo_description, :seo_title]

  index do
    selectable_column
    sortable_handle_column
    column :id
    column :title do |product|
      category =
        link_to I18n.t('active_admin.views.product_category', category: product.product_category_title), [:edit, :admin, product.product_category]
      content_tag(:h4, product.title) +
      content_tag(:p, category)
    end
    # column :description
    column :price do |product|
      content_tag(:p, I18n.t('active_admin.views.price', price: product.price)) +
      content_tag(:p, I18n.t('active_admin.views.discount', discount: product.discount))
    end
    actions
  end

  filter :id
  filter :title
  filter :price
  filter :discount
  filter :admin_user, collection: AdminUser.for_select
  filter :product_category, collection: ProductCategory.for_select
  filter :created_at

  scope :all
  Product::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description
        f.input :price
        f.input :discount
        f.input :admin_user, as: :select, collection: AdminUser.for_select
        f.input :product_category, as: :select, collection: ProductCategory.for_select
        f.input :state, as: :select, collection: Brand.states
      end

      f.inputs I18n.t('active_admin.views.meta') do
        f.input :seo_title
        f.input :seo_description
        f.input :keywords
      end
    end

    f.actions
  end
end

ActiveAdmin.register Product do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 3

  Product::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Product.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  actions :all, except: [:show, :destroy]

  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :description, :state, :admin_user_id, :price, :discount,
    :product_category_id, :position, meta: [:keywords, :seo_description, :seo_title]

  controller do
    def update
      update! do |format|
        format.html {
          redirect_to [:edit, :admin, resource], notice: I18n.t('active_admin.controller.actions.update')
        }
      end
    end
  end

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
    column :description
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
        f.input :discount, as: :wysihtml5
        f.input :admin_user, as: :select2, collection: AdminUser.for_select, selected: resource.admin_user_id
        f.input :product_category, as: :select2, collection: ProductCategory.for_select, selected: resource.product_category_id
        f.input :state, as: :select2, collection: resource_class.states.keys, selected: resource.state
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

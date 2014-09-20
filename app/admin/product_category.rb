ActiveAdmin.register ProductCategory do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 2

  actions :all, except: :show

  sortable tree: true,
    collapsible: true,
    start_collapsed: true,
    max_levels: 3

  permit_params :title, :description, :state, :admin_user_id,
    meta: [:keywords, :seo_description, :seo_title]

  index as: :sortable do
    label :title
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at

  ProductCategory::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description
        f.input :admin_user, as: :select, collection: AdminUser.for_select
        f.input :state, as: :select, collection: ProductCategory.states
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
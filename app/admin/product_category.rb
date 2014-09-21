ActiveAdmin.register ProductCategory do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 2

  actions :all, except: :show

  sortable tree: true,
    collapsible: true,
    start_collapsed: true,
    max_levels: 3

  permit_params :title, :description, :state, :admin_user_id, :parent_id,
    meta: [:keywords, :seo_description, :seo_title]

  index as: :sortable do
    label :title
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at

  scope :all
  ProductCategory::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description
        f.input :admin_user, as: :select2, collection: AdminUser.for_select, selected: resource.admin_user_id
        f.input :parent_id, as: :select2, collection: ProductCategory.for_select, selected: resource.parent.try(:id)
        f.input :state, as: :select2, collection: ProductCategory.states.keys, selected: resource.state
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

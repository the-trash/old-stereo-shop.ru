ActiveAdmin.register Brand do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 1

  actions :all, except: :show
  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :description, :site_link, :state, :admin_user_id,
    :position, meta: [:keywords, :seo_description, :seo_title]

  index do
    selectable_column
    sortable_handle_column
    column :id
    column :title do |brand|
      link =
        if brand.site_link?
          link_to(I18n.t('active_admin.views.site'), brand.site_link, target: '_blank')
        else
          ''
        end

      content_tag(:h4, brand.title) + link
    end
    column :description
    column :created_at
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at
  filter :position

  Brand::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description
        f.input :site_link
        f.input :admin_user, as: :select, collection: AdminUser.for_select
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

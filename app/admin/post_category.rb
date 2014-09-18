ActiveAdmin.register PostCategory do
  menu parent: I18n.t('active_admin.custom_menu.posts'), priority: 1

  actions :all, except: :show

  permit_params :title, :descriton, :state, :admin_user_id,
    meta: [:keywords, :description, :title]

  index do
    selectable_column
    column :id
    column :title
    column :description
    column :created_at
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at

  PostCategory::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description
        f.input :admin_user, as: :select, collection: AdminUser.for_select
        f.input :state, as: :select, collection: PostCategory.states
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

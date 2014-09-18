ActiveAdmin.register Post do
  menu parent: I18n.t('active_admin.custom_menu.posts'), priority: 2

  actions :all, except: :show

  permit_params :title, :description, :full_text, :state, :post_category_id,
    :admin_user_id, meta: [:keywords, :description, :title]

  index do
    column :id
    column :title
    column :description
    column :created_at
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :post_category, collection: PostCategory.for_select
  filter :created_at
  filter :position

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description
        f.input :full_text
        f.input :admin_user, as: :select, collection: AdminUser.for_select
        f.input :post_category, as: :select, collection: PostCategory.for_select
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

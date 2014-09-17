ActiveAdmin.register Post do
  menu parent: I18n.t('active_admin.custom_menu.posts'), priority: 2

  actions :all, except: :show

  permit_params :title, :description, :full_text, :state, :post_category_id,
    meta: [:keywords, :description, :title]

  index do
    column :id
    column :title
    column :description
    column :created_at
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.all.map { |u| [u.email, u.id] }
  filter :post_category, collection: PostCategory.all.map{ |pc| [pc.title, pc.id] }
  filter :created_at
  filter :position

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
    end

    f.actions
  end
end

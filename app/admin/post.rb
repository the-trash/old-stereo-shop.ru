ActiveAdmin.register Post do
  menu parent: I18n.t('active_admin.custom_menu.posts'), priority: 2

  actions :all, except: :show
  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :description, :full_text, :state, :post_category_id,
    :admin_user_id, :position, meta: [:keywords, :seo_description, :seo_title]

  index do
    selectable_column
    sortable_handle_column
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

  Post::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description
        f.input :full_text
        f.input :admin_user, as: :select, collection: AdminUser.for_select
        f.input :post_category, as: :select, collection: PostCategory.for_select
        f.input :state, as: :select, collection: Post.states
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

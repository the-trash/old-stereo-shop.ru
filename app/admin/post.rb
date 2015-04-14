ActiveAdmin.register Post do
  menu parent: I18n.t('active_admin.custom_menu.posts'), priority: 2

  Post::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Post.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  actions :all, except: [:show, :destroy]

  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :description, :full_text, :state, :post_category_id,
    :admin_user_id, :position, :keywords, :seo_description, :seo_title,
    photos_attributes: [:id, :file, :state]

  controller do
    def update
      update! do |format|
        format.html {
          redirect_to [:edit, :admin, resource], notice: I18n.t('active_admin.controller.actions.update')
        }
      end
    end

    def scoped_collection
      Post.includes(:photos)
    end
  end

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

  scope :all
  Post::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description, as: :wysihtml5
        f.input :full_text
        f.admin_users_input(resource)
        f.post_categories_input(resource)
        f.states_input(resource_class.states.keys, resource.state)
      end

      f.inputs I18n.t('active_admin.views.meta') do
        f.input :seo_title
        f.input :seo_description
        f.input :keywords
      end

      f.inputs I18n.t('active_admin.views.photo') do
        f.has_many_photos
      end
    end

    f.actions
  end
end

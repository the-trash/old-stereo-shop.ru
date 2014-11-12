ActiveAdmin.register Page do
  menu parent: I18n.t('active_admin.custom_menu.posts'), priority: 3

  Page::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Page.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  actions :all, except: [:show, :destroy]

  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :short_text, :full_text, :state, :post_category_id,
    :admin_user_id, :position, :keywords, :seo_description, :seo_title

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
    column :title
    column :short_text
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
  Page::STATES.each { |st| scope st }
end

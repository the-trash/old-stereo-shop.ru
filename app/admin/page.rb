ActiveAdmin.register Page do
  menu parent: I18n.t('active_admin.custom_menu.posts'), priority: 3

  Page::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Page.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  actions :all, except: :destroy

  permit_params :title, :short_text, :full_text, :state,
    :admin_user_id, :keywords, :seo_description, :seo_title

  controller do
    def update
      update! do |format|
        format.html {
          redirect_to [:edit, :admin, resource], notice: I18n.t('active_admin.controller.actions.update')
        }
      end
    end

    def show
      redirect_to [:edit, :admin, resource]
    end
  end

  index do
    selectable_column
    column :id
    column :title
    column :short_text
    column :created_at
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at

  scope :all
  Page::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :short_text
        f.input :full_text, as: :wysihtml5
        f.admin_users_input(resource)
        f.states_input(resource_class.states.keys, resource.state)
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

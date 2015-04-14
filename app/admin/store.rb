ActiveAdmin.register Store do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 6

  Product::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Product.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  actions :all, except: [:show, :destroy]

  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :description, :state, :admin_user_id, :latitude, :longitude,
    :happens, :position

  controller do
    def update
      update! do |format|
        format.html {
          redirect_to [:edit, :admin, resource], notice: I18n.t('active_admin.controller.actions.update')
        }
      end
    end
  end

  scope :all
  Store::STATES.each { |st| scope st }

  index do
    selectable_column
    sortable_handle_column
    column :id
    column :title
    column :description

    actions
  end

  filter :id
  filter :title
  filter :happens
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :latitude
        f.input :longitude
        f.input :description, as: :wysihtml5
        f.admin_users_input(resource)
        f.states_input(resource_class.states.keys, resource.state)
        f.input :happens
      end
    end

    f.actions
  end
end

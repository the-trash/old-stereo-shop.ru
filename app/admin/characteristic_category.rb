ActiveAdmin.register CharacteristicCategory do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 4

  actions :all, except: :show

  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :admin_user_id, :position

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
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :position
  filter :created_at

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :admin_user, as: :select2, collection: AdminUser.for_select, selected: resource.admin_user_id
      end
    end

    f.actions
  end
end

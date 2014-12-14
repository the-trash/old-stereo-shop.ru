ActiveAdmin.register Characteristic do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 5

  actions :all, except: :show

  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :characteristic_category_id, :position, :unit

  controller do
    def update
      update! do |format|
        format.html {
          redirect_to [:edit, :admin, resource], notice: I18n.t('active_admin.controller.actions.update')
        }
      end
    end

    def scoped_collection
      Characteristic.includes(:characteristic_category)
    end
  end

  index do
    selectable_column
    sortable_handle_column
    column :id
    column :title
    column :characteristic_category_id do |characteristic|
      link_to characteristic.characteristic_category_title, [:edit, :admin, characteristic.characteristic_category]
    end
    column :unit
    actions
  end

  filter :id
  filter :title
  filter :characteristic_category, collection: CharacteristicCategory.for_select
  filter :position
  filter :unit
  filter :created_at

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :unit
        f.input :characteristic_category, as: :select2, collection: CharacteristicCategory.for_select, selected: resource.characteristic_category_id
      end
    end

    f.actions
  end
end

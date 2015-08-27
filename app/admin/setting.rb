ActiveAdmin.register Setting do
  menu parent: I18n.t('active_admin.custom_menu.settings'), priority: 1
  permit_params :description, :group, :key, :value

  config.filters  = false
  config.paginate = false

  index do
    selectable_column
    column :key
    column :value
    column :description
    column :group
    actions
  end

  form do |f|
    f.inputs do
      f.input :key
      f.input :value
      f.input :description
      f.input :group
    end

    f.actions
  end
end

ActiveAdmin.register City do
  menu parent: I18n.t('active_admin.custom_menu.cities'), priority: 2

  filter :id
  filter :title
  filter :slug
  filter :region
end

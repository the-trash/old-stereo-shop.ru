ActiveAdmin.register Region do
  menu parent: I18n.t('active_admin.custom_menu.cities'), priority: 1

  filter :id
  filter :title
  filter :slug
end

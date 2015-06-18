ActiveAdmin.register PaymentTransaction do
  menu parent: I18n.t('active_admin.custom_menu.orders'), priority: 2

  actions :index, :show
end

ActiveAdmin.register Product::Import do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 7

  batch_action :import do |ids|
    Product::Import.where(id: ids).each(&:start!)
    redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
  end

  actions :all, except: [:destroy, :show]

  permit_params :file, :admin_user_id

  filter :id
  filter :import_entries_count
  filter :completed_import_entries_count
  filter :failed_import_entries_count
  filter :created_at

  scope :all
  Product::Import::IMPORT_STATES.each do |st|
    scope(st) { |scope| scope.with_state(st) }
  end

  controller do
    def build_resource
      @product_import ||= current_admin_user.imports.build(permitted_params[:product_import])
    end
  end

  index do
    selectable_column
    column :id
    column :state
    column :file do |import|
      link_to import.file.file.basename, import.file_url
    end
    column :import_entries_count
    column :completed_import_entries_count
    column :failed_import_entries_count
    column :created_at do |import|
      I18n.l(import.created_at, format: :long)
    end
    actions
  end

  sidebar I18n.t('active_admin.views.additional_info'), only: :edit do
    ul do
      li link_to I18n.t('active_admin.views.products.import.import_entries'), [:admin, resource, :product_import_entries]
    end
  end

  form do |f|
    f.inputs do
      f.input :file
    end
    f.actions
  end
end

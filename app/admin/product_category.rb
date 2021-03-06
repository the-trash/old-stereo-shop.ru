ActiveAdmin.register ProductCategory do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 2

  ProductCategory::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      ProductCategory.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  batch_action :super_destroy do |ids|
    ProductCategory.find(ids).each do |record|
      authorize! ActiveAdmin::Auth::DESTROY, record

      destroy_resource(record)
    end

    redirect_to active_admin_config.route_collection_path(params),
      notice: I18n.t("active_admin.batch_actions.succesfully_destroyed",
      count: ids.count,
      model: active_admin_config.resource_label.downcase,
      plural_model: active_admin_config.plural_resource_label(count: ids.count).downcase)
  end

  actions :all, except: :destroy

  sortable tree: true,
    collapsible: true,
    start_collapsed: true,
    max_levels: 3

  permit_params :title, :description, :state, :admin_user_id, :parent_id,
    :keywords, :seo_description, :seo_title,
    photos_attributes: [:id, :file, :state, :default, :_desctroy]

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

    def scoped_collection
      ProductCategory.includes(:photos)
    end
  end

  index as: :sortable do
    label :title
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at

  scope :all
  ProductCategory::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description, as: :wysihtml5
        f.admin_users_input(resource)
        f.input :parent_id,
          as: :select,
          collection: resource_class.for_select,
          selected: resource.parent.try(:id)
        f.states_input(resource_class.states.keys, resource.state)
      end

      f.inputs I18n.t('active_admin.views.meta') do
        f.input :seo_title
        f.input :seo_description
        f.input :keywords
      end

      f.inputs I18n.t('active_admin.views.photo') do
        f.has_many_photos
      end
    end

    f.actions
  end
end

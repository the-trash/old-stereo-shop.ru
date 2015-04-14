ActiveAdmin.register Brand do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 1

  Brand::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Brand.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  actions :all, except: [:show, :destroy]

  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :description, :site_link, :state, :admin_user_id,
    :position, :keywords, :seo_description, :seo_title

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
    column :title do |brand|
      link =
        if brand.site_link?
          link_to(I18n.t('active_admin.views.site'), brand.site_link, target: '_blank')
        else
          ''
        end

      content_tag(:h4, brand.title) + link
    end
    column :description
    column :created_at
    actions
  end

  filter :id
  filter :title
  filter :admin_user, collection: AdminUser.for_select
  filter :created_at
  filter :position

  scope :all
  Brand::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description, as: :wysihtml5
        f.input :site_link
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

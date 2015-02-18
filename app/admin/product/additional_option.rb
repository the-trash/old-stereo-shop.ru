ActiveAdmin.register Product::AdditionalOption do
  menu false

  belongs_to :product

  navigation_menu :default

  permit_params :product_id, :title, :slug, :render_type

  actions :all, except: [:show, :destroy]

  Product::AdditionalOption::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Product::AdditionalOption.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  controller do
    def build_resource
      @product_additional_option ||= parent.additional_options.
        build(permitted_params[:product_additional_option])
    end

    def update
      update! do |format|
        format.html {
          redirect_to [:edit, :admin, parent, resource], notice: I18n.t('active_admin.controller.actions.update')
        }
      end
    end
  end

  filter :id
  filter :title
  filter :slug
  filter :render_type,
    as: :select,
    collection: Product::AdditionalOption.render_types.map { |k, v| [k, k] }

  index do
    selectable_column
    column :id
    column :title
    column :slug
    column :render_type
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :render_type,
        as: :select2,
        collection: Product::AdditionalOption.render_types.map { |k, v| [k, k] },
        selected: resource.render_type
      f.input :state,
        as: :select2,
        collection: resource_class.states.keys,
        selected: resource.state

      f.actions
    end
  end
end

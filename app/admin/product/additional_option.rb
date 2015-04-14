ActiveAdmin.register Product::AdditionalOption do
  menu false

  belongs_to :product

  navigation_menu :default

  permit_params :product_id, :title, :slug, :render_type,
    photos_attributes: [:id, :file, :state, :_destroy],
    values_attributes: [
      :id, :value, :state, :_destroy,
      new_values_attributes: [
        :id, :new_value, :_destroy, :product_attribute, :state
      ]
    ]

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
      f.input :slug, input_html: { disabled: true }
      f.input :render_type,
        as: :select,
        collection: Product::AdditionalOption.render_types.keys.
          map { |k| [I18n.t(k, scope: [:activerecord, :attributes, :render_types, :render_type]), k] },
        selected: resource.render_type
      f.states_input(resource_class.states.keys, resource.state)
      f.inputs I18n.t('active_admin.views.additional_options_values') do
        f.has_many :values, allow_destroy: true, heading: false do |additional_option|
          additional_option.input :value
          additional_option.input :state,
            as: :select,
            collection: additional_option.object.class.states.keys.
              map { |k| [I18n.t(k, scope: [:activerecord, :attributes, :states, :state]), k] },
            selected: additional_option.object.state
          additional_option.has_many :new_values, allow_destroy: true, heading: false do |option_with_new_value|
            option_with_new_value.input :product_attribute,
              as: :select,
              collection: option_with_new_value.object.class.product_attributes.keys.
                map { |k| [I18n.t(k, scope: [:activerecord, :attributes, :product]), k] },
              selected: option_with_new_value.object.product_attribute
            option_with_new_value.input :new_value
            option_with_new_value.states_input(option_with_new_value.object.class.states.keys, option_with_new_value.object.state)
          end
        end
      end

      f.inputs I18n.t('active_admin.views.photo') do
        f.has_many_photos
      end

      f.actions
    end
  end
end

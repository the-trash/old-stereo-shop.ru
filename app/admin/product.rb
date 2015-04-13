ActiveAdmin.register Product do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 3

  Product::states.each do |st, i|
    batch_action :"#{ st }" do |ids|
      Product.where(id: ids).update_all(state: i)
      redirect_to collection_path, notice: I18n.t('active_admin.views.batch_action', count: ids.size)
    end
  end

  batch_action :super_destroy do |ids|
    Product.find(ids).each do |record|
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

  sortable_list
  config.sort_order = 'position_asc'

  permit_params :title, :description, :state, :admin_user_id, :price, :discount, :brand_id,
    :product_category_id, :position, :keywords, :seo_description, :seo_title, :sku, :euro_price,
    photos_attributes: [:id, :file, :state, :default, :_destroy],
    characteristics_products_attributes: [:id, :characteristic_id, :value, :_destroy],
    products_stores_attributes: [:id, :count, :store_id, :_destroy],
    related_product_ids: [], similar_product_ids: []

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
      Product.includes(:product_category)
    end

    def build_resource
      @product ||= current_admin_user.products.includes(
        :photos, products_stores: :store,
        characteristics: :characteristic_category
      ).build(permitted_params[:product])
    end
  end

  sidebar I18n.t('active_admin.views.additional_info'), only: :edit do
    ul do
      li link_to I18n.t('active_admin.views.products.reviews'), [:admin, resource, :reviews]
      li link_to I18n.t('active_admin.views.products.additional_options'), [:admin, resource, :product_additional_options]
    end
  end

  index do
    selectable_column
    sortable_handle_column
    column :id
    column :title do |product|
      category =
        link_to I18n.t('active_admin.views.product_category',
          category: product.product_category_title), [:edit, :admin, product.product_category]
      content_tag(:h4, product.title) +
      content_tag(:p, category) +
      content_tag(:p, '', class: 'ratable read_only', data: { score: product.average_score })
    end
    column :description
    column :price do |product|
      content_tag(:p, I18n.t('active_admin.views.price', price: product.price)) +
      content_tag(:p, I18n.t('active_admin.views.discount', discount: product.discount))
    end
    actions
  end

  filter :id
  filter :title
  filter :price
  filter :euro_price
  filter :sku
  filter :discount
  filter :average_score
  filter :admin_user, collection: AdminUser.for_select
  filter :product_category, collection: ProductCategory.for_select
  filter :created_at

  scope :all
  Product::STATES.each { |st| scope st }

  form do |f|
    f.inputs do
      f.inputs I18n.t('active_admin.views.main') do
        f.input :title
        f.input :description
        f.input :price
        f.input :euro_price
        f.input :sku
        f.input :discount
        f.input :admin_user, as: :select2,
          collection: AdminUser.for_select,
          selected: resource.admin_user_id
        f.input :product_category, as: :select2,
          collection: ProductCategory.for_select,
          selected: resource.product_category_id
        f.input :state, as: :select2,
          collection: resource_class.states.keys, selected: resource.state
        f.input :brand_id, as: :select2,
          collection: Brand.published.map { |brand| [brand.title, brand.id] },
          selected: resource.brand_id
      end

      f.inputs I18n.t('active_admin.views.meta') do
        f.input :seo_title
        f.input :seo_description
        f.input :keywords
      end

      f.inputs I18n.t('active_admin.views.photo') do
        f.has_many_photos
      end

      f.inputs I18n.t('active_admin.views.characteristics') do
        f.has_many :characteristics_products, allow_destroy: true, heading: false do |char|
          unless char.object.new_record?
            char.form_buffers.last <<
              char.template.content_tag(:li, class: 'string input stringish') do
                char.template.content_tag(:label, I18n.t('active_admin.views.characteristic_category'), class: 'label') +
                char.template.content_tag(:p, char.object.characteristic_characteristic_category_title)
              end
          end
            char.input :characteristic, as: :select2,
              collection: option_groups_from_collection_for_select(
                  CharacteristicCategory.includes(:characteristics).all,
                  :characteristics, :title, :id, :title, char.object.characteristic_id
                )
            char.input :value
        end
      end if Characteristic.any?

      f.inputs I18n.t('active_admin.views.stores') do
        f.has_many :products_stores, allow_destroy: true, heading: false do |pr_store|
          pr_store.input :store, as: :select2,
            collection: options_from_collection_for_select(
              Store.published, :id, :title, pr_store.object.store_id
            )
          pr_store.input :count
        end
      end

      f.input :related_products if Product.any?
      f.input :similar_products if Product.any?
    end

    f.actions
  end
end

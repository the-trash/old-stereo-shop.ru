ActiveAdmin.register Order do
  menu parent: I18n.t('active_admin.custom_menu.orders'), priority: 1

  actions :index, :edit, :update

  permit_params :address, :phone, :user_name, :post_index, :step, :payment, :state,
    :total_amount, :city_id, :delivery, :organization_name, :inn, :kpp, :file,
    line_items_attributes: [:id, :_destroy, :product_id, :quantity, :current_product_price]

  controller do
    def update
      update! do |success, failure|
        success.html do
          resource.send(event_by_state) if event_by_state.presence
          redirect_to [:edit, :admin, resource], notice: I18n.t('active_admin.controller.actions.update')
        end
        failure.html { super }
      end
    end

    def scoped_collection
      Order.includes(:city, :user)
    end

    private

    def state_exists?
      Order.state_names.include? state
    end

    def state
      params[:order][:state]
    end

    def event_by_state
      Order::EVENTS_MAP[state.to_sym]
    end
  end

  index do
    column :id
    column I18n.t('active_admin.views.main') do |order|
      content_tag :ul do
        [
          content_tag(:li, I18n.t('active_admin.views.orders.created_at', date: I18n.l(order.created_at, format: :long)).html_safe),
          content_tag(:li, I18n.t('active_admin.views.orders.total_amount', total_amount: order.total_amount).html_safe),
          content_tag(:li, I18n.t('active_admin.views.orders.city', city_title: (order.city ? order.city_title : '')).html_safe),
          content_tag(:li, I18n.t('active_admin.views.orders.address', address: order.address).html_safe),
          content_tag(:li, I18n.t('active_admin.views.orders.post_index', post_index: order.post_index).html_safe)
        ].join('').html_safe
      end
    end
    column I18n.t('active_admin.views.user') do |order|
      html = content_tag :ul do
        [
          content_tag(:li, I18n.t('active_admin.views.orders.user_name', user_name: order.user_name).html_safe),
          content_tag(:li, I18n.t('active_admin.views.orders.phone', phone: order.phone).html_safe),
          content_tag(:li, I18n.t('active_admin.views.orders.email', email: (order.user ? order.email : '')).html_safe)
        ].join('').html_safe
      end

      cashless = if order.cashless?
        content_tag :ul do
          [
            content_tag(:li, I18n.t('active_admin.views.orders.organization_name', organization_name: order.organization_name).html_safe),
            content_tag(:li, I18n.t('active_admin.views.orders.inn', inn: order.inn).html_safe),
            content_tag(:li, I18n.t('active_admin.views.orders.kpp', kpp: order.kpp).html_safe),
            content_tag(:li, I18n.t('active_admin.views.orders.file', href: order.file_url).html_safe)
          ].join('').html_safe
        end
      end

      html + cashless
    end
    column :step do |order|
      content_tag(:p, I18n.t(order.step, scope: [:activerecord, :attributes, :order, :steps]))
    end
    column :state do |order|
      content_tag(:p, I18n.t(order.state, scope: [:activerecord, :attributes, :order, :states]))
    end
    column :payment do |order|
      content_tag(:p, I18n.t(order.payment, scope: [:activerecord, :attributes, :order, :payments]))
    end
    column :delivery do |order|
      content_tag(:p, I18n.t(order.delivery, scope: [:activerecord, :attributes, :order, :deliveries]))
    end
    actions
  end

  filter :id
  # filter :user, collection: User.all.inject([]) { |_, user| _ << [user.email, user.id] }
  filter :state, as: :select, collection: Order.state_names.inject([]) { |_, state| _ << [I18n.t(state, scope: [:activerecord, :attributes, :order, :states]), state] }
  filter :step, as: :select, collection: Order.steps.map { |step, i| [I18n.t(step, scope: [:activerecord, :attributes, :order, :steps]), i] }
  filter :payment, as: :select, collection: Order.payments.map { |payment, i| [I18n.t(payment, scope: [:activerecord, :attributes, :order, :payments]), i] }
  filter :delivery, as: :select, collection: Order.deliveries.map { |delivery, i| [I18n.t(delivery, scope: [:activerecord, :attributes, :order, :deliveries]), i] }
  filter :user_name
  filter :created_at

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs I18n.t('active_admin.views.main') do
      f.form_buffers.last <<
        f.template.content_tag(:li, class: 'input required stringish') do
          f.template.content_tag(:label, (I18n.t('activerecord.attributes.order.city') + content_tag(:abbr, '*', title: 'required')).html_safe, class: 'label', for: 'order_city') +
          f.template.content_tag(:input, nil, type: 'hidden', id: 'order_city', name: 'order[city]', data: { search_path: cities_path, searching: t('searching'), not_found: t('cities.no_matches_found') }, class: 'get-cities', value: resource.city.try(:id))
        end
      f.input :address
      f.input :phone
      f.input :user_name
      f.input :post_index
      f.input :total_amount
    end
    f.inputs do
      f.input :state, as: :select,
        collection: Order.state_names.inject([]) { |_, state| _ << [
          I18n.t(state, scope: [:activerecord, :attributes, :order, :states]), state
        ] },
        selected: f.object.state

      f.input :step, as: :select,
        collection: Order.steps.keys.map { |step| [I18n.t(step, scope: [:activerecord, :attributes, :order, :steps]), step] },
        selected: f.object.step

      f.input :payment, as: :select,
        collection: Order.payments.keys.map { |payment| [I18n.t(payment, scope: [:activerecord, :attributes, :order, :payments]), payment] },
        selected: f.object.payment

      f.input :delivery, as: :select,
        collection: Order.deliveries.keys.map { |delivery| [I18n.t(delivery, scope: [:activerecord, :attributes, :order, :deliveries]), delivery] },
        selected: f.object.delivery
    end

    if f.object.cashless?
      f.inputs I18n.t('active_admin.views.orders.cashless') do
        f.input :organization_name
        f.input :inn
        f.input :kpp
        f.input :file
        if f.object.file?
          f.form_buffers.last <<
            f.template.content_tag(:li, class: 'string input stringish') do
              f.template.content_tag(:label, I18n.t('active_admin.views.orders.details'), class: 'label') +
              f.template.content_tag(:a, I18n.t('active_admin.views.orders.details'), href: f.object.file_url, target: '_blank')
            end
        end
      end
    end

    f.inputs I18n.t('active_admin.views.line_items') do
      f.has_many :line_items, allow_destroy: true, heading: false do |line|
        line.input :product, as: :select,
          collection: options_from_collection_for_select(
            Product.published, :id, :title, line.object.product_id
          )
        line.input :quantity
        line.input :current_product_price
      end
    end

    f.actions
  end
end

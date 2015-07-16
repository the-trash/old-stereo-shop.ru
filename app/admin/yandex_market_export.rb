ActiveAdmin.register YandexMarketExport do
  menu parent: I18n.t('active_admin.custom_menu.products'), priority: 8

  config.breadcrumb = false

  actions :index, :new

  controller do
    def new
      if resource.save
        redirect_to [:admin, :yandex_market_exports], notice: I18n.t('active_admin.controller.actions.create')
      else
        redirect_to [:admin, :yandex_market_exports], alert: resource.errors.full_messages.join("\r\n")
      end
    end

    private

    def resource
      @yandex_market_export ||= YandexMarketExport.new
    end
  end

  filter :id
  filter :state, as: :select, collection: YandexMarketExport.state_names.inject([]) { |_, state| _ << [I18n.t(state, scope: [:activerecord, :attributes, :yandex_market_export, :states]), state] }
  filter :created_at

  index do
    column :id
    column :state do |yandex_market_export|
      content_tag(:p, I18n.t(yandex_market_export.state, scope: [:activerecord, :attributes, :yandex_market_export, :states]))
    end
    column :file do |yandex_market_export|
      file_url = yandex_market_export.file.url
      link_to File.basename(file_url), file_url if file_url.presence
    end
    column :created_at do |yandex_market_export|
      content_tag :p, I18n.l(yandex_market_export.created_at, format: :long)
    end
  end
end

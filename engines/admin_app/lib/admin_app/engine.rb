module AdminApp
  class Engine < ::Rails::Engine
    isolate_namespace AdminApp

    autoload_paths = %w(
      app/queries
      app/services
      app/forms
      app/policies
    ).map{ |path| "#{config.root}/#{path}" }

    config.autoload_paths   += autoload_paths
    config.eager_load_paths += autoload_paths

    config.i18n.load_path += Dir['engines/admin_app/config/locales/**/*.{rb,yml}']

    initializer :asset_precompile_paths do |app|
      app.config.assets.precompile += %w(
        admin_app/admin.js
        admin_app/admin.css
        admin_app/modules/products/index_page/index.js
      )
    end
  end
end

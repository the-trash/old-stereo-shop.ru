# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  select2/*.png
  select2/*.gif
  i18n/translations.js
  modules/order_in_one_click/index.js
  html5shiv/dist/html5shiv-printshiv.min.js
  html5shiv/dist/html5shiv.min.js
)

Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.precompile << Proc.new { |path| path =~ /fontawesome\/fonts/ and File.extname(path).in?(['.otf', '.eot', '.svg', '.ttf', '.woff', '.woff2']) }

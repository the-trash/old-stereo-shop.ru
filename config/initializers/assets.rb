# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  select2/*.png
  select2/*.gif
)

Rails.application.config.assets.paths << File.join(Rails.root, 'vendor/assets')
Rails.application.config.assets.paths << File.join(Rails.root, 'vendor/assets', 'bower_components', 'select2')

$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'admin_app/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'admin_app'
  s.version     = AdminApp::VERSION
  s.authors     = ['Alexey Solomkin']
  s.email       = ['justsnow17@yandex.ru']
  s.homepage    = 'http://stereo-shop.ru'
  s.summary     = 'Admin app for stereo-shop store'
  s.description = 'Admin app for stereo-shop store'
  s.license     = 'MIT'

  s.files = Dir['{app,config,lib}/**/*', 'README.markdown']

  s.add_dependency 'rails'
end

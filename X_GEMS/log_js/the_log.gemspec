# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'log_js/version'

Gem::Specification.new do |spec|
  spec.name          = "log_js"
  spec.version       = LogJS::VERSION
  spec.authors       = ["Ilya N. Zykin"]
  spec.email         = ["zykin-ilya@ya.ru"]
  spec.summary       = %q{JS: log() instead console.log() in your Rails App}
  spec.description   = %q{Replace `console.log` with `log` in your Rails App}
  spec.homepage      = "https://bitbucket.org/rails_commercial_solutions/log_js"
  spec.license       = "`Rails Commercial Solutions` Commerce License"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "coffee-rails"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end

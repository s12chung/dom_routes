# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dom_routes/version'

Gem::Specification.new do |spec|
  spec.name          = "dom_routes"
  spec.version       = DomRoutes::VERSION
  spec.authors       = ["s12chung"]
  spec.email         = ["steve@placemarkhq.com"]
  spec.description   = %q{ Auto-magical scaffolding for Paul Irish's DOM-based Routing way of organizing your javascript. }
  spec.summary       = %q{ Auto-magical scaffolding for Paul Irish's DOM-based Routing way of organizing your javascript. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 3.1'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "capybara-webkit"
  spec.add_development_dependency "jbuilder"
  spec.add_development_dependency "jquery-rails"
  spec.add_development_dependency "rake"
end
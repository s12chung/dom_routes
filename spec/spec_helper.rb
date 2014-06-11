$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'fake_app/fake_app'
require 'capybara-webkit'
require 'rspec/rails'

Capybara.javascript_driver = :webkit
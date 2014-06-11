$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'action_controller'

require 'dom_routes'

require 'fake_app/fake_app'

require 'rspec/rails'

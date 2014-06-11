require 'rails'
require 'action_controller/railtie'
require 'action_view/railtie'

module FakeApp
  class Application < Rails::Application
    config.secret_token = 'Listen to your heart. Be brave. Do what you gotta do.'
    config.session_store :cookie_store, :key => 'session_store'
    config.active_support.deprecation = :log
    config.eager_load = false
  end
end
FakeApp::Application.initialize!

%w[routes].each do |file|
  require "fake_app/#{file}"
end

%w[controllers helpers].each do |file|
  require "fake_app/app/#{file}"
end
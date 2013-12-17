require "dom_routes/view_helpers"
require "dom_routes/controller"

module DomRoutes
  if defined?(Rails) && defined?(Rails::Engine)
    class Engine < ::Rails::Engine
      initializer "dom_routes.view_helpers" do
        ActionView::Base.send :include, ViewHelpers
      end
    end
  end
end
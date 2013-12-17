module DomRoutes
  class Route
    attr_accessor :controller_path, :action

    def set(controller_path, action)
      self.controller_path = controller_path
      self.action = action
    end

    def controller_namespace
      controller_path.gsub("/", ".")
    end

    def parts
      [controller_path, action]
    end

    def to_s
      "#{controller_path}/#{action}"
    end
    def ==(route)
      parts == route.parts
    end
  end

  module Controller
    extend ActiveSupport::Concern
    included do
      helper_method :js_route
      helper_method :js_route=
      helper_method :extract_js_route
    end

    protected
    def js_route; @js_route || extract_js_route end
    def js_route=(js_route); @js_route = extract_js_route js_route end
    def flash_js_route(js_route=self.js_route)
      flash[:js_route] = extract_js_route(js_route).to_s
    end

    def extract_js_route(js_route=nil)
      extracted_route = Route.new
      extracted_route.set controller_path, action_name

      if js_route
        if js_route.class == Route
          extracted_route = js_route
        elsif js_route.class.ancestors.include? Hash
          extracted_route = HashWithIndifferentAccess.new(js_route)
        else
          split = js_route.to_s.split('/')
          extracted_route.action = split.last

          controller = split[0..-2]
          unless controller.empty?
            extracted_route.controller_path = controller.join('/')
          end
        end
      end
      extracted_route
    end
  end
end

::ActionController::Base.send :include, DomRoutes::Controller
module DomRoutes
  module ViewHelpers
    #http://stackoverflow.com/questions/339130/how-do-i-render-a-partial-of-a-different-format-in-rails
    def with_format(format, &block)
      old_formats = formats
      self.formats = [format]
      result = block.call
      self.formats = old_formats
      result
    end

    def with_js_route(js_route)
      old_js_route = self.js_route
      self.js_route = js_route
      result = yield
      self.js_route = old_js_route
      result
    end

    def js_params_namespace(js_route=self.js_route)
      raw "DR.routes.#{js_route.controller_namespace}.#{formats.first}.#{js_route.action}_params"
    end

    def js_params_value(js_route=self.js_route)
      controller_path, action = js_route.parts

      params = { controller: controller_path, action: action, method: request.method, path: request.env['PATH_INFO'], format: formats.first }
      if self.respond_to? :add_params; params.reverse_merge! add_params end

      javascript = params.to_json
      if block_given?
        generated_params = yield
        if generated_params
          javascript = "$.extend(#{generated_params}, #{javascript});"
        end
      end
      raw javascript
    end

    def execute_js_routes
      raw "#{execute_flash_js_route}\n#{execute_js_route}"
    end

    def execute_js_route(js_route=self.js_route, format=formats.first)
      js_route = extract_js_route(js_route)
      controller_path, action = js_route.parts
      lambda = -> do
        if format == :html
          javascript_tag do
            raw %Q/
                DR.create_namespace('#{js_params_namespace}');
                #{js_params_namespace} = #{ js_params_value do
                  with_format :js do
                    if lookup_context.template_exists? "#{controller_path}/#{action}_params"
                      render(template: "#{controller_path}/#{action}_params")
                    end
                  end
                end };
                #{
            if is_flash_js_route?
              %Q/$(function() { DR.exec_all(#{js_params_namespace}); });/
            else
              %Q/
                    DR.define_namespace('DR.routes', {
                        params: #{js_params_namespace}
                    });
                    $(function() { DR.exec_all(#{js_params_namespace}); });
                  /
            end
            }
                /
          end
        elsif format == :js
          with_format :js do
            content_for :head do
              javascript_tag do
                raw "$(function(){#{render template: "#{controller_path}/#{action}", formats: [:js], layout: "layouts/application"}});"
              end
            end
          end
        end
      end

      if js_route != self.js_route
        with_js_route(js_route) { lambda.call }
      else
        lambda.call
      end
    end

    def execute_flash_js_route
      flash_js_route = flash[:js_route]
      if flash_js_route
        with_flash_js_route do
          execute_js_route extract_js_route(flash_js_route)
        end
      end
    end

    def with_flash_js_route
      @is_flash_js_route = true
      result = yield
      @is_flash_js_route = false
      result
    end
    def is_flash_js_route?
      @is_flash_js_route
    end
  end
end
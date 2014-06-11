//= require dom_routes
//= require_self
//= require_tree .

test_append = function(filter, params) {
    var $div = $(document.createElement('div'));
    $div.addClass(filter);
    $div.append(params.s);
    $('#test_append').append($div);
};

create_routes = function(controller_namespace) {
    DR.define(controller_namespace, {
        html: {
            before: function(params) {
                test_append(controller_namespace + ".before", params);
            },
            index: function(params) {
                test_append(controller_namespace + ".index", params);
            },
            with_parameters: function(params) {
                test_append(controller_namespace + ".with_parameters", params);
            },
            after: function(params) {
                test_append(controller_namespace + ".after", params);
            }
        }
    });
};
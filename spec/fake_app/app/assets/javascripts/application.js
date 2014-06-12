//= require jquery_ujs
//= require dom_routes
//= require_self
//= require_tree .

test_append = function(controller_namespace, filter, params) {
    var $div = $(document.createElement('div'));
    $div.attr("filter", controller_namespace + "." + params.format + "." + filter);
    $div.append(params.s);
    $('#test_append').append($div);
};

create_routes = function(controller_namespace) {
    var test = function(filter, params) {
        test_append(controller_namespace, filter, params);
    };

    DR.define(controller_namespace, {
        html: {
            before: function(params) {
                test("before", params);
            },
            index: function(params) {
                test("index", params);
            },
            with_parameters: function(params) {
                test("with_parameters", params);
            },
            manually_execute: function(params) {
                test("manually_execute", params);
            },
            after: function(params) {
                test("after", params);
            }
        },
        js: {
            before: function(params) {
                test("before", params);
            },
            with_parameters: function(params) {
                test("with_parameters", params);
            },
            after: function(params) {
                test("after", params);
            }
        }
    });
};
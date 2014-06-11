//= require dom_routes
//= require_self
//= require_tree .

test_append = function(filter, params) {
    var $div = $(document.createElement('div'));
    $div.addClass(filter);
    $div.append(params.s);
    $('#test_append').append($div);
};
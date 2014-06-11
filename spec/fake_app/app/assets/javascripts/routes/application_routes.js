(function() {
    var application = DR.define('application', {
        html: {
            before: function(params) {
                test_append("application.before", params);
            },
            index: function(params) {
                test_append("application.index", params);
            },
            after: function(params) {
                test_append("application.after", params);
            }
        }
    });
})();
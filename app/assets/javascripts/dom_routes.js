DR = {
    namespace_prefix: "DR.routes",
    blank: function(o) {
        return typeof o === "undefined" || o === null;
    },
    namespace_string: function(namespace_string) {
        return DR.namespace_prefix + "." + namespace_string;
    },
    get_or_create: function(namespace_string) {
        var current_namepace = window;
        $.each(namespace_string.split('.'), function(index, level) {
            if (DR.blank(current_namepace[level]))
                current_namepace[level] = {};
            current_namepace = current_namepace[level];
        });

        return current_namepace;
    },
    define: function(namespace_string, definition) {
        namespace_string = DR.namespace_string(namespace_string);
        return DR.define_namespace(namespace_string, definition);
    },
    define_namespace: function(namespace_string, definition) {
        var found_namespace = DR.get_or_create(namespace_string);
        return $.extend(found_namespace, definition);
    },

    traverse_namespace: function(namespace, levels) {
        if (!$.isArray(levels)) levels = [levels.controller, levels.format, levels.action];
        levels = DR.formatted_levels(levels);

        var current_level = namespace;
        var level;
        for (var i=0;i<levels.length;i++) {
            level = levels[i];
            current_level = current_level[level];
            if (typeof current_level === "undefined") return undefined;
        }
        return current_level;
    },
    formatted_levels: function(levels) {
        var formatted_levels = [];
        var level;
        for (var i=0;i<levels.length;i++) {
            level = levels[i];
            formatted_levels = formatted_levels.concat(level.split('/'));
        }
        return formatted_levels;
    },

    create_namespace: function(namespace) {
        var current_level = window;
        $.each(namespace.split("."), function(index, level) {
            if (!$.isPlainObject(current_level[level])) current_level[level] = {};
            current_level = current_level[level];
        });
    },

    exec_all: function(params) {
        DR.exec("application", params.format, "before", params);
        DR.exec(params.controller, params.format, "before", params);
        DR.exec("application", params.format, params.action, params);
        DR.exec(params.controller, params.format, params.action, params);
        DR.exec(params.controller, params.format, "after", params);
        DR.exec("application", params.format, "after", params);
    },
    exec: function(controller, format, action, params) {
        var action_namespace = DR.traverse_namespace(DR.routes, [controller, format, action]);
        if ($.isFunction(action_namespace)) action_namespace(params);
    }
};
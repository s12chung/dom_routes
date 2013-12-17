# PokeJs
Auto-magical scaffolding for
[Paul Irish's DOM-based Routing](http://www.paulirish.com/2009/markup-based-unobtrusive-comprehensive-dom-ready-execution/)
(or Garber-Irish Implementation) way of organizing your javascript.

## Purpose
Javascript is hard to organize and debugging ajax is a mess. This is one method to organizing your javascript neatly by mirroring the controllers and having all the it outside of your HTML views.

## How it works
### Setup your namespace
```javascript
DR.routes = {
	all: {
		html: {
			before: function() {
			}
		}
	},
	demos: {
		html: {
			before: function() {
			},
			demo_action: function() {
			}
		}
	}
}
```
### What happens
After, requests to `demos#demo_action` with format `html` will call the following functions (if they exist):
* `DR.routes.all.html.before`
* `DR.routes.demos.html.before`
* `DR.routes.demos.html.demo_action` (with parameters if given)
* `DR.routes.demos.html.after`
* `DR.routes.all.html.after`

`js` format is also supported, i.e.:
* `DR.routes.all.js.before`
* `DR.routes.demos.js.before`
* `DR.routes.demos.js.demo_action` (with parameters if given)
* `DR.routes.demos.js.after`
* `DR.routes.all.js.after`

## Installation
Add this line to your application's `Gemfile`:

    gem 'dom_routes'

And then execute:

    $ bundle

Add this to your `app/assets/javascripts/application.js`

    //= require dom_routes

Make sure your `app/views/layouts/application.html.erb` (and all your other layouts) looks like this:
```erb
<html>
<head>… <%= execute_js_routes %> …</head>
<body data-controller="<%= js_route.controller_path %>" data-action="<%= js_route.action %>">
    …
</body>
</html>
```

## Basic Use
I like to have a JS file for every route in `app/assets/javascripts/routes`. Like so:

`app/assets/javascripts/routes/demos.js`:
```javascript
(function() {
	var demos = DR.define('demos', {
		html: {
			edit: function(params) {
				alert(params.alert_message);
			}
		},

		js: {
			new: function(params) {
				console.log(params.log_message);
			}
		}
	});
})();
```

`DR.define()` extends or creates the namespace `DR.routes.demos`
and returns it. This allows me to access `DR.routes.demos` through
the `demos` variable. You can also use the traditional hash
namespacing shown in the [Setup your namespace](https://github.com/s12chung/dom_routes#setup-your-namespace) section.

So if a `html` request is sent to `demos#edit`, `DR.routes.demos.html.edit` is called with the HTML view rendering.

For a `js` request sent to `demos#new`, `DR.routes.demos.js.new` is called and nothing else happens.

### Passing parameters
__Optional__ Parameters are passed from a JSON DSL (such as [jbuilder](https://github.com/rails/jbuilder/)) and is passed as the `params` object to the function. You can pass any JSON object.

#### HTML
`app/views/demos/edit_params.js.jbuilder`:
```ruby
json.alert_message "ploop"
```
so 
```javascript
DR.routes.demos.html.edit({ alert_message: "ploop" });
```
is called automatically.

#### Javascript
`app/views/demos/new.js.jbuilder`:
```ruby
json.log_message "loggggggggggggg"
```
so
```javascript
DR.routes.demos.js.new({ log_message: "loggggggggggggg" });
```
is called automatically.

## Advanced Use
### Manually execute a route
Use `#execute_js_route(js_route=self.js_route, format=formats.first)`

### Executing a different route
Sometimes you want to execute a different route too. For that, you can specify it like so:
```ruby
self.js_route = "demos/edit" # can be "demos#edit", "edit", { controller: "demos", action: "edit" }, or a DomRoutes::Route object
```
When this is done, the original route and the new route will be executed.

### Handling redirects with flash
Other times you may want to use a route after a redirect, use `#flash_js_route(js_route=nil)` then.

## Credits
Extracted out of [Placemark](https://www.placemarkhq.com/). Originally called [poke_js](https://github.com/s12chung/poke_js).

## Contribution
Feel free to fork, post issues or send any pull requests. Thanks.
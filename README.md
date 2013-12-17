# PokeJs
Auto-magical scaffolding for
[Paul Irish's DOM-based Routing](http://www.paulirish.com/2009/markup-based-unobtrusive-comprehensive-dom-ready-execution/)
(or Garber-Irish Implementation) way of organizing your javascript.

## Purpose
Javascript is hard to organize and debugging ajax is a mess. This is one method to organizing your javascript neatly by mirroring the controllers and having all the it outside of your HTML views.

## How it works
### Setup your namespace
```javascript
APP = {
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
* `DOM_ROUTES.routes.all.html.before`
* `DOM_ROUTES.routes.demos.html.before`
* `DOM_ROUTES.routes.demos.html.demo_action` (with parameters if given)
* `DOM_ROUTES.routes.demos.html.after`
* `DOM_ROUTES.routes.all.html.after`

`js` format is also supported, i.e.:
* `DOM_ROUTES.routes.all.js.before`
* `DOM_ROUTES.routes.demos.js.before`
* `DOM_ROUTES.routes.demos.js.demo_action` (with parameters if given)
* `DOM_ROUTES.routes.demos.js.after`
* `DOM_ROUTES.routes.all.js.after`

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
<body data-controller="<%= js_template.controller_path %>" data-action="<%= js_template.action %>">
    …
</body>
</html>
```

## Basic Use
I like to have a JS file for every controller in `app/assets/javascripts/controllers`. Like so:

`app/assets/javascripts/controllers/demos.js`:
```javascript
(function() {
	var demos = DOM_ROUTES.define('demos', {
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

`DOM_ROUTES.define()` extends or creates the namespace `DOM_ROUTES.demos`
and returns it. This allows me to access `DOM_ROUTES.demos` through
the `demos` variable.

You can also use the traditional hash
namespacing shown in the [Setup your namespace](https://github.com/s12chung/dom_routes#setup-your-namespace) section.

### HTML
So if a `html` request is sent to `demos#edit`, `DOM_ROUTES.routes.demos.html.edit` is called with the HTML view rendering.

### Javascript
For a `js` request sent to `demos#new`, `DOM_ROUTES.routes.demos.js.new` is called and nothing else happens.

### Passing parameters
__Optional__ Parameters are passed from a JSON DSL (such as [jbuilder](https://github.com/rails/jbuilder/)) and is passed as the `params` object to the function. You can pass any JSON object.

#### HTML
`app/views/demos/edit_params.js.jbuilder`:
```ruby
json.alert_message "ploop"
```
so 
```javascript
DOM_ROUTES.routes.demos.html.edit({ alert_message: "ploop" });
```
is called automatically.

#### Javascript
`app/views/demos/new.js.jbuilder`:
```ruby
json.log_message "loggggggggggggg"
```
so
```javascript
DOM_ROUTES.routes.demos.js.new({ log_message: "loggggggggggggg" });
```
is called automatically.

## Advanced Use
Sometimes you want to execute a different route.
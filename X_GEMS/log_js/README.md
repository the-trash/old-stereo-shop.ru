# LogJS

Take care of your joints. Write less, do same.

Replace `console.log` with `log` in your Rails App

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'log_js'
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install log_js
```

## Usage

**application.js**

```coffeescript
//= require jquery
//= require log_js
```

**layouts/application.html.haml**

```haml
!!!
%html{ data: { log_js: Rails.env.development? } }
%head
  %title My Application
  = stylesheet_link_tag    :application, media: :all
  = javascript_include_tag :application
  = csrf_meta_tags

%body
  / ....
```

or for SLIM

```slim
head(data-log-js=Rails.env.development?)
```

**Into your Browser Console**

```javascript
log('Hello World!')
```

**Into your CoffeeScript code**

```coffeescript
# DOM 'ready' event
$ ->
  log 'Hello World!'
```

## LogJS and Production env

Nobody wants to see `log` messages in web console in production mode.
You can configure visibility of `log` messages with `data-log-js` param

```haml
%AnyTag{ data: { log_js: Rails.env.development? } }
```

or you can switch it in JS console

```javascript
LogJS.enable = true  // log messages will be visible
LogJS.enable = false // there are no log messages
```

## MIT licence

#= require commonjs/common
#= require jquery/dist/jquery
#= require jquery-ujs/src/rails

#= require underscore/underscore
#= require underscore.string/lib/underscore.string
#= require backbone/backbone
#= require backbone.babysitter/lib/backbone.babysitter
#= require backbone.wreqr/lib/backbone.wreqr
#= require marionette/lib/backbone.marionette
#= require backbone.modelbinder/Backbone.ModelBinder.min
#= require backbone.paginator/lib/backbone.paginator.min

#= require lib/backbone/attributes_type_casting.module
#= require lib/backbone/associations_manager.module
#= require lib/backbone/ajax_validation.module
#= require lib/backbone/enhanced_events_declaration
#= require lib/backbone/extentions
#= require lib/backbone/marionette_extensions
#= require lib/backbone/rails_model

#= require select2/select2
#= require select2/select2_locale_ru

#= require hamlcoffee
#= require admin_app/routes
#= require i18n

#= require bootstrap-sass/assets/javascripts/bootstrap/dropdown
#= require bootstrap-sass/assets/javascripts/bootstrap/collapse
#= require bootstrap-sass/assets/javascripts/bootstrap/tab
#= require bootstrap-sass/assets/javascripts/bootstrap/modal

#= require_self

_.mixin(_.string.exports())

window.withElement = (selector, callback) ->
  callback selector if $(selector).length

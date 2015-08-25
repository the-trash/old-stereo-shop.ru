AttributesTypeCasting = require 'lib/backbone/attributes_type_casting'
AjaxValidation        = require 'lib/backbone/ajax_validation'
AssociationsManager   = require 'lib/backbone/associations_manager'

class Backbone.RailsModel extends Backbone.Model
  @include AttributesTypeCasting
  @include AjaxValidation

  # Override original method to support associations and guaranty to initialize function runs last
  constructor: (attributes, options = {}) ->
    attrs       = attributes or {}
    options   ||= {}
    @cid        = _.uniqueId 'c'
    @attributes = {}
    @collection = options.collection if options.collection

    attrs = @parse(attrs, options) or {} if options.parse
    attrs = _.defaults {}, attrs, _.result(@, 'defaults')

    @set attrs, options
    @associationsManager = new AssociationsManager this
    @typeCastAttributes()
    @changed = {}
    @initialize.apply @, arguments

  defaults: {}

  # TODO use camelcase here
  save_associations: []
  save_methods: []
  save_attributes: ->
    _.keys _.result(this, 'defaults')
  skip_attributes: []
  as_json: (options) ->
    save_attributes = _.result(this, 'save_attributes')
    skip_attributes = _.result(this, 'skip_attributes')
    save_associations = _.result(this, 'save_associations')
    save_methods = _.result(this, 'save_methods')

    attrs = _.pick this.toJSON(), _(save_attributes).difference(skip_attributes)

    for association in save_associations
      if data = this[association] || @get(association)
        data = data.as_json() if data.as_json?
        attrs["#{association}_attributes"] = data
    for method in save_methods
      data = this[method]()
      if data or data == '' or data == 0
        attrs[method] = data

    attrs = _.extend attrs, options

    @deepReplaceNulls attrs

  sync: (method, model, options) =>
    options.data = _.extend {}, options.data, _.result(this, 'urlParams') if @urlParams
    super method, model, options

  save: (attributes = null, options = {}) ->
    this.set attributes
    super null, this.setDataAttribute(options)

  updateAttributes: (attributes) ->
    @save null, updateAttributes: attributes

  setDataAttribute: (options) ->
    attributes = options.updateAttributes
    delete options.updateAttributes
    attributes   = @preparedDataAttributes attributes
    attributes   = _.extend {}, options.data, attributes
    options.data = attributes
    options

  preparedDataAttributes: (selectedAttributes) ->
    _({}).tap (attributes) =>
      attributes[ _.result(this, 'resourceName') || 'model' ] = selectedAttributes or @as_json()

  resourceName: ->
    string = _.underscored(_.result(this, 'className')).replace('::', '_')
    if _.isEmpty(string) then null else string

  deepReplaceNulls: (object) =>
    for key, val of object
      object[key] = '' if _.isNull(val) || _.isUndefined(val) || _.isNaN(val)
      @deepReplaceNulls(object[key]) if _.isObject(object[key]) && !_.isFunction(object[key])
    object

  markForDestruction: (options = {}) =>
    if @isNew()
      @collection.remove(this)
    else
      @set _destroy: true

    unless options.silent
      @trigger 'markedForDestruction'
      @collection.trigger 'markedForDestruction', this, @collection if @collection

  isDeleted: =>
    !!@get('_destroy')

_.extend Backbone.RailsModel, Modulable

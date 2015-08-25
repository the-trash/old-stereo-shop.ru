#= require ../modulable

Backbone.emulateJSON = true

_.extend Backbone.Collection::,
  as_json: (block) ->
    @map (model) =>
      _.tap model.as_json(), (attributes) =>
        block.call this, model, attributes if _.isFunction(block)

  prev: (for_item) ->
    @at @indexOf(for_item) - 1

  next: (for_item) ->
    @at @indexOf(for_item) + 1

_.extend Backbone.Model::,
  isFirst: ->
    this is @collection.first()

  isLast: ->
    this is @collection.last()

  prev: ->
    @collection.prev this

  next: ->
    @collection.next this

_.extend Backbone.View::,
  bindDatalinks: (bindings...) ->
    args = [@model, @$el]
    args.push bindings...
    @modelBinder ||= new Backbone.ModelBinder
    @modelBinder.bind.apply @modelBinder, args

  unbindDatalinks: ->
    @modelBinder?.unbind()

  preventDefault: (event) ->
    event.preventDefault()

  stopPropagation: (event) ->
    event.stopPropagation()

  suppressEnterKeypress: (event) ->
    if event.which is 13
      event.preventDefault()
    else
      event.stopImmediatePropagation()

_.extend Backbone.View, Modulable
_.extend Backbone.Model, Modulable
_.extend Backbone.Collection, Modulable

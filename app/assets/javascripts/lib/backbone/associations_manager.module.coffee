class AssociationsManager
  constructor: (@model) ->
    @setModelAssociations()
    @extendModelSetter()

  extendModelSetter: ->
    old_method = @model.set
    @model.set = (attributes, options) =>
      old_method.call @model, @detectAndUpdateAssociatedObjects(attributes, options), options

  detectAndUpdateAssociatedObjects: (attributes, options) ->
    newAttributes = _(attributes).clone()
    for key, values of newAttributes
      newAttributes[key] = @updateAssociatedObject(key, values, options) if @isAssociationDefined(key)
    newAttributes

  isAssociationDefined: (association) ->
    association in @modelAssociationNames()

  isHasOneAssociation: (association) ->
    association in _.keys(@hasOneDefinitions())

  isHasManyAssociation: (association) ->
    association in _.keys(@hasManyDefinitions())

  updateAssociatedObject: (association, values, options) ->
    switch
      when @isHasManyAssociation(association)
        @updateHasManyAssociation.apply this, arguments
      when @isHasOneAssociation(association)
        @updateHasOneAssociation.apply this, arguments

  updateHasManyAssociation: (association, values, options) ->
    _(@model.get(association)).tap (collection) ->
      collection.reset values, options

  updateHasOneAssociation: (association, values, options) ->
    _(@model.get(association)).tap (model) ->
      model.set values, options

  setModelAssociations: ->
    for association, klass of @modelAssociations()
      unless _.isFunction(klass)
        throw "Expected :#{association} to be a collection constructor, gets `#{typeof klass}`"

      attributes = {}
      attributes[association] = new klass @model.get(association)
      @model.set attributes

  modelAssociationNames: ->
    @cachedAssociationNames ||= _.keys @modelAssociations()

  modelAssociations: ->
    @cachedAssociations ||= _.extend {}, @hasManyDefinitions(), @hasOneDefinitions()

  hasManyDefinitions: ->
    @cachedHasManyDefinitions ||= _.result(@model, 'hasMany') || {}

  hasOneDefinitions: ->
    @cachedHasOneDefinitions ||= _.result(@model, 'hasOne') || {}

module.exports = AssociationsManager

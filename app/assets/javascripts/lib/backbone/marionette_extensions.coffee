Marionette = Backbone.Marionette

getTemplate = (template) ->
  if _.isFunction(template) then template else JST["templates/#{template}"] or JST[template]

Marionette.Renderer.render = (template, data) ->
  template = getTemplate(template) or throw new Error "Template '#{template}' not found!"
  template(data)

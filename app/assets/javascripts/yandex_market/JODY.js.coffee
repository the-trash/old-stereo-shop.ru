#################################
# SIMPLE LOG
#################################
#
unless @log
  @log = -> try console.log arguments...

#################################
# JSON HELPERS
#################################
#
@json2data = (str, _default = []) ->
  try
    JSON.parse str
  catch e
    log str
    log "JSON parse error: #{ e }"
    _default

@data2json = (data, _default = '[]') ->
  try
    JSON.stringify data
  catch e
    log data
    log "JSON stringify error: #{ e }"
    _default

#################################
# JodyNotificator
#################################

# JodyNotificator.clean()
# JodyNotificator.show_error("Message")
# JodyNotificator.show_errors({ errors: { field_name_1: ["hello"], field_name_2: ["world"] } })
# JodyNotificator.show_flash({ flash: { alert: "Hello World!" })

@JodyNotificator = do ->
  processor: (data) ->
    JodyNotificator.clean() unless data.keep_alerts
    JodyNotificator.errors data.errors
    JodyNotificator.error  data.error
    JodyNotificator.flashs data.flash

  clear: -> @clean()
  clean: -> log 'JodyNotificator.clean() not implemented'

  errors: (errors)       -> log errors
  error:  (error)        -> log error

  flashs: (flashs)       -> log flashs
  flash:  (method, _msg) -> log method, msg

#################################
# JodyJS
#################################
#
# JodyJS.processor({ js_exec: { "SomeModule.some_method": [1,2,3] } })
#
@JodyJS = do ->
  processor: (data) ->
    @js_functions_exec(data)

  js_functions_exec: (data) ->
    if fus = data?.js_exec
      for fu_data in fus
        for fu, args of fu_data
          if _fu = @funct_exists(fu)
            _fu(args)
    true

  # As a variant
  # "key1.key2.key3".split(‘.’).reduce(function(a,k){return a[k]}, object)
  #
  funct_exists: (fu_path) ->
    fu = window
    fu_path = fu_path.split '.'

    for part in fu_path
      (fu = null; break) unless fu[part]
      (fu = fu[part])
    fu

#################################
# JodyRedirect
#################################
#
# JodyRedirect.processor({ page_reload:  true })
# JodyRedirect.processor({ redirect_to:  "https://google.com" })
# JodyRedirect.processor({ replace_with: "https://google.com" })
#
@JodyRedirect = do ->
  reload:                 -> do location.reload
  to:               (url) -> window.location.href  = url
  location_replace: (url) -> window.location.replace url

  processor: (data) ->
    @reload()              if data.page_reload
    @to rurl               if rurl = data.redirect_to
    @location_replace lurl if lurl = data.replace_with

#################################
# JODY Modals
#################################
#
# JodyModal.processor({ modal: { hide: true } })
#
@JodyModal = do ->
  processor: (data) ->
    if data?.modal?.hide is true
      log "JodyModal not implemented"

#################################
# JODY Forms
#################################
#
# JodyForm.processor(processor, { form: { reset: true } })
#
@JodyForm = do ->
  processor: (xhr, data) ->
    return false unless (form = $ xhr.currentTarget).is('form')
    do form[0].reset if data?.form?.reset is true

#################################
# JODY HTML
#################################
#
# json.set! :html_content, {
#   append: {
#     ".test_append_1" => "Test append/1",
#     ".test_append_2" => "Test append/2",
#     ".test_append_3" => "Test append/3"
#   },
#   replace: {
#     ".test_replace_1" => "Text for replace/1",
#     ".test_replace_2" => "Text for replace/2",
#     ".test_replace_3" => "Text for replace/3"
#   },
#   destroy: [ ".test_destroy_1", ".test_destroy_2", ".test_destroy_3" ],

#   attrs: {
#     append: {
#       '.test_attrs' => { 'data-title' => "Hello world!", alt: "New Picture", title: "New Picture" }
#     },
#     replace: {
#       '.test_attrs' => { src: "https://avatars0.githubusercontent.com/u/496713" }
#     },
#     destroy: {
#       '.test_attrs' => [ :title, :alt ]
#     }
#   }
# }
#
# json.set! :js_exec, [
#   { "console.log" => "hello world!" },
#   { "console.log" => { test: 1, test_2: 2 } }
# ]
#
@JodyHtml = do ->
  processor: (data) ->
    @change_html(data)
    @change_attrs(data)
    @change_props(data)

  change_html: (data) ->
    @html_content_destroy(data)
    @html_content_replace(data)
    @html_content_append(data)
    @html_content_set(data)
    @html_value_set(data)

  change_attrs: (data) ->
    @attrs_change(data)
    @attrs_destroy(data)
    @attrs_replace(data)
    @attrs_remove_value(data)
    @attrs_append(data)

  html_content_append: (data) ->
    if ids = data?.html_content?.append
      for id, content of ids
        $(id).append content

  html_content_set: (data) ->
    if ids = data?.html_content?.set_html
      for id, content of ids
        $(id).html content

  html_value_set: (data) ->
    if ids = data?.html_content?.set_value
      for id, value of ids
        $(id).val value

  html_content_replace: (data) ->
    if ids = data?.html_content?.replace
      for id, content of ids
        $(id).replaceWith content

  html_content_destroy: (data) ->
    if ids = data?.html_content?.destroy
      for id in ids
        $(id).remove()

  attrs_change: (data) ->
    if change_attrs = data?.html_content?.change_attrs
      for id, _attrs of change_attrs
        if (item = $ id).length
          for attr_name, val of _attrs
            item.attr(attr_name, val)

  attrs_destroy: (data) ->
    if delete_attrs = data?.html_content?.attrs?.destroy
      for id, _attrs of delete_attrs
        if (item = $ id).length
          for attr_name in _attrs
            item.removeAttr attr_name

  attrs_replace: (data) ->
    if replace_attrs = data?.html_content?.attrs?.replace
      for id, _attrs of replace_attrs
        if (item = $ id).length
          for attr_name, val of _attrs
            item.attr(attr_name, val)

  attrs_remove_value: (data) ->
    if remove_attrs = data?.html_content?.attrs?.remove_value
      for id, _attrs of remove_attrs
        if (item = $ id).length
          for attr_name, val of _attrs
            original_value = item.attr(attr_name) || ''
            item.attr attr_name, original_value.replace(val, '')

  attrs_append: (data) ->
    if add_attrs = data?.html_content?.attrs?.append
      for id, _attrs of add_attrs
        if (item = $ id).length
          for attr_name, val of _attrs
            original_value = item.attr(attr_name) || ''
            item.attr(attr_name, "#{ original_value } #{ val }".trim())

  change_props: (data) ->
    if props = data?.html_content?.props
      for id, _props of props
        if (item = $ id).length
          for prop_name, val of _props
            item.prop(prop_name, val)

#################################
# Jody Inline Errors
#################################
#
# Отрисовка Inline ошибок в форму
#
@JodyInlineErrors = do ->
  processor: (data) ->
    # reset error fields style
    if errors = data?.inline_errors
      for filed_name, _errors of errors
        text_field_id = ".inlineErrorFor#{ filed_name }"

        text_field = $ text_field_id

        for field, errs of _errors
          text_field.text errs[0]

#################################
# JODY: JSON for DYnamic sites
#################################
#
@JODY = do ->
  processor: (data, status, response) ->
    JodyRedirect.processor(data)
    JodyHtml.processor(data)
    JodyJS.processor(data)

    JodyNotificator.processor(data)
    JodyModal.processor(data)

  error_processor: (xhr, response, status) ->
    if typeof (data = json2data(response.responseText, _default = NaN)) is "object"
      JodyNotificator.processor(data)
      JodyInlineErrors.processor(data)
    else
      if (response.status isnt 0) and (response.status isnt 200)
        JodyNotificator.show_error("#{ response.statusText }: #{ response.status }")

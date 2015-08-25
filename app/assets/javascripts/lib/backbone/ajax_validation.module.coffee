AjaxValidation =
  validationUrl: ->
    "#{@url()}/validate"

  ajaxValidate: (ajaxOptions = {}) ->
    options =
      url  : _.result(@, 'validationUrl')
      data : _.extend({}, @preparedDataAttributes(), Util.authData())

      beforeSend: (data, status, xhr) =>
        ajaxOptions.beforeSend?.call this, data, status, xhr
        @trigger 'validated:ajax:beforeSend', data, status, xhr

      success: (data, status, xhr) =>
        ajaxOptions.success?.call this, data, status, xhr
        @trigger 'validated:ajax:success', data, status, xhr

        if data.errors
          @trigger 'validated:invalid', data.errors
        else
          @trigger 'validated:valid', data

      error: (xhr, status, error) =>
        ajaxOptions.error?.call this, xhr, status, error
        try
          if (data = $.parseJSON xhr.responseText) and data.errors
            @trigger 'validated:invalid', data.errors
        catch error
          @trigger 'validated:ajax:error', xhr, status, error
          console.debug error

      complete: (xhr, status) =>
        ajaxOptions.complete?.call this, xhr, status
        @trigger 'validated:ajax:complete', xhr, status

      dataType : 'json'

    $.ajax options

module.exports = AjaxValidation

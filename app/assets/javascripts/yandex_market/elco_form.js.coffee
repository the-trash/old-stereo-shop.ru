@ElcoForm = do ->
  init: ->
    $('.js--elco-import').on 'ajax:success', (xhr, data, status) ->
      JODY.processor(data)

    $('.js--elco-update-form').on 'ajax:success', (xhr, data, status) ->
      JODY.processor(data)

    submit_inputs = $('.js--elco-form-submit')

    submit_inputs.on 'focusin', (e) ->
      input = $ e.currentTarget
      input.data 'orig_val', input.val()

    submit_inputs.on 'focusout', (e) ->
      input    = $ e.currentTarget
      curr_val = input.val().trim()
      orig_val = input.data('orig_val').trim()

      if curr_val isnt orig_val
        input.parents('form').submit()
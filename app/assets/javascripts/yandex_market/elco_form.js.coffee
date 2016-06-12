@ElcoImport = do ->
  tracker_start: ->
    ElcoImport.status_checker ||= setInterval ->
      $('.js--elco_check').click()
    , 5000

  tracker_stop: ->
    log('>>>', ElcoImport.status_checker)
    clearInterval(ElcoImport.status_checker)
    ElcoImport.status_checker = null

@ElcoForm = do ->
  init: ->
    ElcoImport.tracker_start()

    $('.js--elco_check').on 'ajax:success', (xhr, data, status) ->
      JODY.processor(data)

    $('.js--elco-import').on 'click', ->
      ElcoImport.tracker_start()

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
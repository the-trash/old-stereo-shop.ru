@MarketCheckbox = do ->
  init: ->
    doc = $ document

    doc.on 'change', '.ya-market--checkbox', (e) ->
      checkbox =  $ e.target
      form = checkbox.parents('form')
      form.submit()
class Ratable
  constructor: (el) ->
    if $(el).hasClass('read_only')
      @initReadOnly(el)
    else
      @initClickRaty(el)

  initReadOnly: (el) ->
    $(el).raty
      score: $(el).data('score')
      readOnly: true

  initClickRaty: (el) ->
    $(el).raty
      click: (score, evt) ->
        $('#review_rating_score').val(score)

@Ratable = Ratable

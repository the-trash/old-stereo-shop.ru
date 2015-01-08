class CitiesSelect
  constructor: (el: @el, options: @options) ->
    @initSelect()

  initSelect: ->
    @el.select2($.extend {}, @defaultOptions(), @options)
      .select2('data', @selectedCities)

  defaultOptions: ->
    minimumInputLength: 3
    width: 'copy'
    ajax:
      url: @el.data('search-path')
      dataType: 'json'
      data: (searchText) -> query: searchText
      results: (data) -> results: data
    formatResult: @formatCityToString
    formatSelection: @formatCityToString
    formatSearching: @el.data('searching')
    formatNoMatches: @el.data('not-found')
    initSelection: (element, callback) ->
      id = $(element).val()

      if id != ''
        $.ajax('/cities/' + id,
          dataType: 'json'
        ).done (data) ->
          callback data

  formatCityToString: (city) ->
    "#{ city.region_title } - #{ city.title }"

@CitiesSelect = CitiesSelect

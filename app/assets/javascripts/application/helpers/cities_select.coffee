class CitiesSelect
  constructor: (el: @el, options: @options) ->
    @initSelect()

  initSelect: ->
    @el.select2($.extend {}, @defaultOptions(), @options)
      .select2('data', @selectedCities)

  defaultOptions: ->
    multiple: true
    minimumInputLength: 1
    width: 'copy'
    ajax:
      url: @el.data('search-path')
      dataType: 'json'
      data: (searchText) -> query: searchText, limit: gon.selector_search_limit
      results: (data) -> results: data
    formatResult: @formatCityToString
    formatSelection: @formatCityToString
    formatSearching: @el.data('searching')
    formatNoMatches: @el.data('not-found')

  formatCityToString: (city) ->
    city.title

@CitiesSelect = CitiesSelect

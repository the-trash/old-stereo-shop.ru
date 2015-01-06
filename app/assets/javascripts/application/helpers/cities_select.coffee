class CitiesSelect
  constructor: (el: @el, options: @options) ->
    @initSelect()
    # TODO: add initSelection

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

  formatCityToString: (city) ->
    "#{ city.region_title } - #{ city.title }"

@CitiesSelect = CitiesSelect

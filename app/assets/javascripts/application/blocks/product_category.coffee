class ProductCategoryShowPage
  form = $('.filter-products-form')

  constructor: ->
    @filterByBrand()
    @filterByShow()

  filterByBrand: ->
    _this = @
    $('.brands').on 'click', 'li > a', (e) ->
      e.preventDefault()
      _this.setValAndSubmitForm('.filter-by-brand', $(this).data('id'))

  filterByShow: =>
    _this = @
    $('.show').on 'click', 'li > a', (e) ->
      e.preventDefault()
      _this.setValAndSubmitForm('.filter-by-show', $(this).data('sort-by'))

  setValAndSubmitForm: (element, value) ->
    $(element).val(value)
    form.submit()

@ProductCategoryShowPage = ProductCategoryShowPage

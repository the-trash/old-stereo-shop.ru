class Cart
  constructor: ->
    _this = @

    $('.b-cart').on 'click', '.arrow:not(.disabled)', (e) ->
      _this.arrowClick(this)

    $('.b-cart').on 'change', '.quantity', (e) ->
      _this.changeQuantityField($(this))

  changeProductsCount: (count) ->
    $('body').find('.cart-items-counter').each (index, element) ->
      current_count = parseInt $(this).text()

      $(this).text(parseInt(current_count + count))

  changeTotalAmountForLine: (count, quantityField) ->
    totalAmount = quantityField.closest('tr').find('.total_amount')
    price       = totalAmount.data('price')

    totalAmount.text @priceWithCurrency(parseFloat(price * count))

    @changeCartTotalAmount()

  arrowClick: (arrow) ->
    role  = $(arrow).data('role')
    form  = $(arrow).closest('form')
    count = 1

    quantityField = form.find('.quantity')
    quantityValue = parseInt(quantityField.val())

    decrementArrow = form.find('.arrow[data-role="decrement"]')

    if role == 'increment'
      count = quantityValue + 1
      @changeProductsCount(1)

      decrementArrow.removeClass('disabled') if decrementArrow.hasClass('disabled')
    else if quantityValue > 1 && role == 'decrement'
      count = quantityValue - 1
      @changeProductsCount(-1)
    else
      decrementArrow.addClass('disabled')

    quantityField.val(count)
    quantityField.attr('data-value', count)
    @changeTotalAmountForLine(count, quantityField, role)

    @sendAjax(form.attr('action'), count, quantityField)

  sendAjax: (url, count, quantityField) ->
    $.ajax
      url: url
      data:
        line_item:
          quantity: count
          id: quantityField.data('id')
      dataType: 'json'
      type: 'PATCH'
      success: (data) ->
        # console.log data

  changeCartTotalAmount: ->
    container = $('.cart-total-amount')
    total     = parseFloat container.attr('data-total')
    amount    = 0

    $('.total_amount').each ->
      amount += parseFloat($(this).text())

    container.attr 'data-total', amount
    container.text @priceWithCurrency(amount)

  priceWithCurrency: (price) ->
    price + ' руб.'

  changeQuantityField: (quantityField) ->
    form     = quantityField.closest('form')
    quantity = parseInt(quantityField.val())

    if quantity >= 1
      @changeTotalAmountForLine(quantity, quantityField)
      @changeCartTotalAmount()

      @sendAjax(form.attr('action'), quantity, quantityField)
    else
      quantityField.val(quantityField.data('value'))

@Cart = Cart

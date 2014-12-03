class Cart
  constructor: ->
    _this = @

    $('body').on 'click', '.arrow:not(.disabled)', (e) ->
      _this.arrowClick(this)

  changeProductsCount: (count) ->
    $('body').find('.cart-items-counter').each (index, element) ->
      current_count = parseInt $(this).text()

      $(this).text(parseInt(current_count + count))

  changeTotalAmountForLine: (count, quantityField, role) ->
    totalAmount = quantityField.closest('tr').find('.total_amount')
    price       = totalAmount.data('price')

    totalAmount.text @priceWithCurrency(parseFloat(price * count))

    @changeCartTotalAmount(parseFloat(price), role)

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
    @changeTotalAmountForLine(count, quantityField, role)

    data =
      line_item:
        quantity: count
        id: quantityField.data('id')

    @sendAjax(form.attr('action'), data)

  sendAjax: (url, formData) ->
    $.ajax
      url: url
      data: formData
      dataType: 'json'
      type: 'PATCH'
      success: (data) ->
        # console.log data

  changeCartTotalAmount: (count, role) ->
    container = $('.cart-total-amount')
    total     = parseFloat container.attr('data-total')

    amount = if role == 'decrement'
      parseFloat(total - count)
    else
      parseFloat(total + count)

    container.attr 'data-total', amount

    container.text @priceWithCurrency(amount)

  priceWithCurrency: (price) ->
    price + ' руб.'

@Cart = Cart

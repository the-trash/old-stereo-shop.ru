module ProductsHelper
  def price_with_discount(price, with_discount, options = { default_classes: 'price' })
    content_tag(:div, class: options[:default_classes]) do
      if price == with_discount
        product_price(price, { class: 'product-price' })
      else
        product_discount(with_discount, { class: 'new product-price-with-discount' }) +
        product_price(price, { class: 'old product-price' })
      end
    end
  end

  def class_with_content_for_count_in_stock(happens, count)
    klass, text =
      if happens
        if count > 0
          ['in_store', products_count_in_store(count)]
        else
          ['not_in_store', I18n.t('views.product.not_in_store')]
        end
      else
        ['not_heppens', I18n.t('views.product.in_store.not_heppens')]
      end

    {
      class: klass,
      content: text
    }
  end

  def products_count_in_store(count)
    [
      I18n.t('views.product.in_store.prefix'),
      I18n.t('views.product.in_store.products_count', count: count)
    ].join(' ')
  end

  def link_or_title_for_store(store)
    if store.happens
      link_to store.title, store
    else
      store.title
    end
  end

  def add_to_wishlist product, opts = {}
    options = opts.merge!({
      remote: true,
      method: :post,
      data: {
        role: 'add-to-wish',
        id: product.id
      }
    })

    i = content_tag :i, '', class: 'icon icon-i-like'

    link =
      if current_user.wishes.pluck(:product_id).include?(product.id)
        link_to(I18n.t('delete'), [:remove_from_wishlist, product])
      else
        link_to(I18n.t('i_like'), [:add_to_wishlist, product], options)
      end

    (i + link).html_safe
  end

  def product_price(price, options = {})
    content_tag(
      :p,
      I18n.t('views.product.with_currency', coust: price),
      options
    )
  end

  def product_discount(with_discount, options = {})
    content_tag(
      :p,
      I18n.t('views.product.with_currency', coust: with_discount),
      options
    )
  end
end

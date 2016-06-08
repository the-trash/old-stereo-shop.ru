module ProductsHelper
  def price_with_discount(product, options = { default_classes: 'price' })
    price = product.price
    with_discount = product.price_with_discount

    if product.elco_id.present?
      return product_price product.total_elco_price
    end

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
          #['in_store', products_count_in_store(count)]
          ['in_store', nil]
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

  # TODO: add decorator for product
  def add_to_wishlist product, options = {}
    options.reverse_merge! default_wishlist_options(product)
    wishlist_id = options[:wishlist_id].present? ? options[:wishlist_id] : @front_presenter.user_wishlist[product.id]

    link_body, link_path, link_options =
      if current_user.wishes.product_exists?(product.id)
        [I18n.t('delete'), product_wishlist_path(product, wishlist_id), options.merge!(wishlist_delete_options)]
      else
        [I18n.t('i_like'), product_wishlists_path(product), options.merge!(method: :post)]
      end

    link_to link_path, link_options do
      [make_tag, content_tag(:span, link_body)].join('').html_safe
    end
  end

  def product_price(price, options = {})
    make_tag :p, I18n.t('views.product.with_currency', coust: price_formatted(price)), options
  end

  def product_discount(with_discount, options = {})
    make_tag :p, I18n.t('views.product.with_currency', coust: price_formatted(with_discount)), options
  end

  def make_tag tag = :i, body = '', options = { class: 'fa fa-fw fa-heart' }
    content_tag tag, body, options
  end

  def icon_in_stock(in_stock, classes = nil)
    l_classes = [
      classes,
      'l-product-instock',
      (in_stock ? 'product-in-stock' : 'product-out-off-stock')
    ].compact.join(' ').strip

    content_tag :div, class: l_classes do
      [
        content_tag(:i, '', class: "fa fa-fw #{(in_stock ? 'fa-check' : 'fa-exclamation-circle')}"),
        content_tag(:span, product_in_stock_message(in_stock))
      ].join('').html_safe
    end
  end

  def characteristic_with_unit value, unit
    content_tag :span, [value, ("(#{unit})" if unit.present?)].join(' ')
  end

  def price_formatted price
    int_price = price.to_i

    if int_price > 0 && price % int_price == 0
      int_price
    else
      price
    end
  end

  def linked_product_preview product, *args
    link_to [product], title: product.title do
      background_image_tag ImageDecorator.decorate(product).photo_url *args
    end
  end

  private

  def product_in_stock_message in_stock
    in_stock ? I18n.t('in_stock') : I18n.t('product_is_availible_to_order')
  end

  def default_wishlist_options(product)
    {
      data: {
        role: 'add-to-wish',
        id: product.id
      },
      class: 'b-add-to-wishlist'
    }
  end

  def wishlist_delete_options
    {
      method: :delete,
      confirmation: I18n.t('are_you_sure')
    }
  end
end

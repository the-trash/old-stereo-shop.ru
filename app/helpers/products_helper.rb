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

  # TODO: add decorator for product
  def add_to_wishlist product, options = {}
    options.reverse_merge! default_wishlist_options(product)
    wishlist_id = options[:wishlist_id].present? ? options[:wishlist_id] : @user_wishlist[product.id]

    link =
      if current_user.wishes.product_exists?(product.id)
        link_to(I18n.t('delete'), product_wishlist_path(product, wishlist_id), options.merge!(wishlist_delete_options))
      else
        link_to(I18n.t('i_like'), product_wishlists_path(product), options.merge!(method: :post))
      end

    (make_tag + link).html_safe
  end

  def product_price(price, options = {})
    make_tag :p, I18n.t('views.product.with_currency', coust: price), options
  end

  def product_discount(with_discount, options = {})
    make_tag :p, I18n.t('views.product.with_currency', coust: with_discount), options
  end

  def make_tag tag = :i, body = '', options = { class: 'icon icon-i-like' }
    content_tag tag, body, options
  end

  private

  def default_wishlist_options(product)
    {
      data: {
        role: 'add-to-wish',
        id: product.id
      }
    }
  end

  def wishlist_delete_options
    {
      method: :delete,
      confirmation: I18n.t('are_you_sure')
    }
  end
end

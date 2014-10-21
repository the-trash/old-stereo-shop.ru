module ProductsHelper
  def price_with_discount(product)
    content_tag(:div, class: 'price') do
      if product.discount != 0.0
        content_tag(:p, product.price_with_discount, class: 'new') +
        content_tag(:p, product.price, class: 'old')
      else
        content_tag(:p, product.price)
      end
    end
  end
end

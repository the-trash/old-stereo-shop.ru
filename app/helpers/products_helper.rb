module ProductsHelper
  def price_with_discount(product)
    content_tag(:div) do
      if product.discount != 0.0
        content_tag(:p, product.price_with_discount) +
        content_tag(:p, product.price)
      else
        content_tag(:p, product.price)
      end
    end
  end
end

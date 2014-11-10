module ProductCategoriesHelper
  def active_class_by_params(current_element, by_params)
    current_element == by_params ? 'active' : nil
  end

  def build_sale_product_categories_ancestry_tree(collection, options = {})
    collection.map { |item, sub_items|
      sale_one_li(item, sub_items, options)
    }.join.html_safe
  end

  def sale_product_category_nested_tree(items, options = {})
    return if items.empty?

    result = items.map { |item, sub_items| sale_one_li(item, sub_items, options) }.join.html_safe

    content_tag :ul, result, class: 'children'
  end

  def sale_classes(item, options = {})
    active   = options[:active] == item.slug ? 'active' : nil
    disabled = item.sale ? nil : 'disabled'

    [active, disabled].compact.join(' ').presence
  end

  def sale_one_li(item, sub_items, options = {})
    return unless item

    content_tag :li, class: sale_classes(item, options) do
      raw(
        link_or_paragraf(item) +
        sale_product_category_nested_tree(sub_items, options = {})
      )
    end
  end

  def link_or_paragraf(item)
    if item.sale
      link_to("#{ item.title } (#{ item.sale_products_count })", [:sale, item])
    else
      content_tag(:p, "#{ item.title } (#{ item.sale_products_count })")
    end
  end
end

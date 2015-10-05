module AncestryHelper
  def product_category_nested_tree items, options = {}
    return unless items.any?

    result = items.map do |item, children|
      content_tag :li, class: ('dropdown-submenu' if children.any?) do
        [
          product_category_link(item, children.any?),
          product_category_nested_tree(children)
        ].join.html_safe
      end
    end.join.html_safe

    content_tag :ul, result, class: 'dropdown-menu'
  end

  def product_category_link item, has_children
    if has_children
      content_tag :div, item.title, class: 'dropdown-item', data: { dropdown: true }
    else
      link_to item.title, [item]
    end
  end

  def item_photo item, options = {}
    image_tag(ImageDecorator.decorate(item).photo_url(:product_category), options)
  end
end

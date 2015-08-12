module ApplicationHelper
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def build_product_category_ancestry_tree(collection, options = {})
    default_options = {
      with_image: false,
      child_ul_class: nil,
      li_with_child_class: nil,
      with_arrow: true
    }
    opts = options.reverse_merge! default_options

    collection.map { |item, sub_items|
      has_items = sub_items.empty?
      child_class = ancestry_tree_child_class has_items
      arrow = arrow_for_ancestry_tree has_items, opts[:with_arrow]
      image = item_photo item, opts[:with_image]

      content_tag :li, class: [child_class, opts[:li_with_child_class]].compact.join('').presence do
        [
          image,
          product_category_link(item, { class: parent_product_category_link_class(has_items) }),
          arrow,
          product_category_nested_tree(sub_items, opts)
        ].compact.join.html_safe
      end.html_safe
    }.join.html_safe
  end

  def product_category_nested_tree(items, options = {})
    return if items.empty?

    result = items.map { |item, sub_items|
      content_tag :li, class: 'b-product-category-item', data: { id: item.id } do
        [
          product_category_link(item),
          product_category_nested_tree(sub_items, options)
        ].compact.join.html_safe
      end
    }.join.html_safe

    content_tag(:ul, result, class: ul_children_classes(options), 'aria-labelledby' => 'dropdownMenu' ).html_safe
  end

  def dropdown_product_category_nested_tree items
    return if items.empty?

    result = items.map { |item, sub_items|
      content_tag :li, class: ('dropdown-submenu' if sub_items.any?) do
        [
          product_category_link(item),
          dropdown_product_category_nested_tree(sub_items)
        ].join.html_safe
      end
    }.join.html_safe

    content_tag :ul, result, class: 'dropdown-menu'
  end

  def build_dropdown_product_category_nested_tree items
    items.map { |item, sub_items|
      content_tag :li, class: ('dropdown-submenu' if sub_items.any?) do
        [
          product_category_link(item),
          dropdown_product_category_nested_tree(sub_items)
        ].join.html_safe
      end
    }.join.html_safe
  end

  def active_class_for_page(params, slug)
    params[:page] == slug ? 'active' : nil
  end

  def split_by_divider string, divider = ';'
    string.present? ? string.split(divider) : []
  end

  private

  def ancestry_tree_child_class has_items
    'with-children' unless has_items
  end

  def arrow_for_ancestry_tree has_items, with_arrow
    content_tag :span, '&#x25BC;'.html_safe, class: 'b-dropdown-arrow', data: { toggle: 'dropdown' } if !has_items && with_arrow
  end

  def item_photo item, with_image
    if with_image && item.photos.any?
      link_to [item], class: 'without-border' do
        image_tag(item.photos.default.file_url(:product_category), class: 'grayscale grayscale-fade').html_safe
      end
    end
  end

  def product_category_link item, options = {}
    options.reverse_merge! title: item.title
    link_to item.title, [item], options
  end

  def ul_children_classes options
    [
      'children',
      'dropdown-menu',
      options[:child_ul_class]
    ].compact.join(' ')
  end

  def parent_product_category_link_class has_items
    [
      'b-product-category-parent-link',
      ('b-link-with-child' unless has_items)
    ].compact.join ' '
  end
end

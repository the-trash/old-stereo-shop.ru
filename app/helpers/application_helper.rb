module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def build_product_category_ancestry_tree(collection, options = {})
    opts = {
      with_image: false,
      child_ul_class: '',
      li_with_child_class: nil,
      with_arrow: true
    }.merge!(options)

    collection.map { |item, sub_items|
      child_class, arrow = sub_items.empty? ? [nil, nil] : ['with-children', (content_tag(:span, '&#x25BC;'.html_safe, class: 'arrow down') if opts[:with_arrow])]
      image =
        if opts[:with_image]
          item.photos.any? ? image_tag(item.photos.first.file_url(:product_category), class: 'grayscale grayscale-fade').html_safe : ''
        else
          ''
        end

      content_tag :li, class: [child_class, opts[:li_with_child_class]].compact.join('').presence do
        [
          image,
          link_to(item.title, [item], data: { id: item.id }),
          arrow,
          product_category_nested_tree(sub_items, opts)
        ].compact.join('').html_safe
      end.html_safe
    }.join.html_safe
  end

  def product_category_nested_tree(items, options = {})
    return if items.empty?

    result = items.map { |item, sub_items|
      "<li>#{ link_to(item.title, [item], data: { id: item.id }) }#{ product_category_nested_tree(sub_items, options) }</li>"
    }.join

    "<ul class=\"#{ 'children' + options[:child_ul_class] }\">#{ result }</ul>".html_safe
  end

  def active_class_for_page(params, slug)
    params[:page] == slug ? 'active' : nil
  end
end

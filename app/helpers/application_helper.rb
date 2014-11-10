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
      li_with_child_class: ''
    }.merge!(options)

    collection.map { |item, sub_items|
      child_class, arrow = sub_items.empty? ? ['', nil] : ['with-children', content_tag(:span, '&#x25BC;'.html_safe, class: 'arrow down')]
      image = opts[:with_image] ? image_tag('category.jpg', class: 'grayscale grayscale-fade').html_safe : ''

      "<li class=\"#{ child_class + opts[:li_with_child_class] }\">" + image +
      "#{ link_to(item.title, [item], data: { id: item.id }) } #{ arrow }" +
      "#{ product_category_nested_tree(sub_items, opts) }</li>"
    }.join.html_safe
  end

  def product_category_nested_tree(items, options = {})
    return if items.empty?

    result = items.map { |item, sub_items|
      "<li>#{ link_to(item.title, [item], data: { id: item.id }) }#{ product_category_nested_tree(sub_items, options) }</li>"
    }.join

    "<ul class=\"#{ 'children' + options[:child_ul_class] }\">#{ result }</ul>".html_safe
  end
end

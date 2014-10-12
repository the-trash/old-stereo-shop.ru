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

  def build_product_category_ancestry_tree(collection)
    collection.map { |item, sub_items|
      "<li>#{ link_to(item.title, [item], data: { id: item.id }) } #{ product_category_nested_tree(sub_items) }</li>"
    }.join.html_safe
  end

  def product_category_nested_tree(items)
    return if items.empty?

    result = items.map { |item, sub_items|
      "<li>#{ link_to(item.title, [item], data: { id: item.id }) }#{ product_category_nested_tree(sub_items) }</li>"
    }.join

    "<ul class='children'>#{ result }</ul>".html_safe
  end
end

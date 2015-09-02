module ApplicationHelper
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def active_class_for_page(params, slug)
    params[:page] == slug ? 'active' : nil
  end

  def split_by_divider string, divider = ';'
    string.present? ? string.split(divider) : []
  end

  def cart_btn product_id, options
    button_to line_items_path(product_id: product_id), options do
      cart_icon_with_text
    end
  end

  def cart_icon_with_text
    [
      content_tag(:i, '', class: 'fa fa-shopping-cart fa-fw'),
      content_tag(:span, I18n.t('add_to_cart'))
    ].join('').html_safe
  end

  private

  def ancestry_tree_child_class has_items
    'with-children' unless has_items
  end

  def background_image_tag url, options = {}
    opt = { class: 'e-image' }.merge(options).with_indifferent_access
    style = { style: "background-image: url('#{image_url url}'); " }
    style[:style] += opt.delete(:style) if opt.has_key? :style
    content_tag :div, nil, opt.merge(style)
  end
end

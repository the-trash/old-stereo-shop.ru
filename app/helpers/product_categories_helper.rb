module ProductCategoriesHelper
  def active_class_by_params(current_element, by_params)
    current_element == by_params ? 'active' : ''
  end
end

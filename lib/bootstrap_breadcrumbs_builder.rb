# The BootstrapBreadcrumbsBuilder is a Bootstrap compatible breadcrumb builder.
# It provides basic functionalities to render a breadcrumb navigation according to Bootstrap's conventions.
#
# BootstrapBreadcrumbsBuilder accepts a limited set of options:
# * separator: what should be displayed as a separator between elements
#
# You can use it with the :builder option on render_breadcrumbs:
#     <%= render_breadcrumbs :builder => ::BootstrapBreadcrumbsBuilder, :separator => "&raquo;" %>
#
# Note: You may need to adjust the autoload_paths in your config/application.rb file for rails to load this class:
#     config.autoload_paths += Dir["#{config.root}/lib/"]
#
class BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    @context.content_tag(:ul, class: 'breadcrumbs') do
      @elements.map.with_index { |element, i|
        render_element(element, i)
      }.join.html_safe
    end
  end

  def render_element(element, i)
    first = i == 0
    current = @context.current_page?(compute_path(element))

    @context.content_tag(:li, class: ('active' if current) || ('home' if first)) do
      link_or_text = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options)
      divider = @context.content_tag(:span, (@options[:separator]  || '/').html_safe, class: 'divider') unless current

      ((first ? home_icon : '') + link_or_text + (divider || '')).html_safe
    end
  end

  private

  def home_icon
    @context.link_to Rails.application.routes.url_helpers.root_path do
      @context.content_tag :i, '', class: 'fa fa-fw fa-home'
    end
  end
end

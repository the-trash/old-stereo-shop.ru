module AdminApp
  module SidebarHelper
    def sidebar_dropdown_link title
      link_to '#', class: 'dropdown-toggle', data: { toggle: 'dropdown' } do
        [
          content_tag(:span, title),
          content_tag(:span, nil, class: 'caret')
        ].join.html_safe
      end
    end
  end
end

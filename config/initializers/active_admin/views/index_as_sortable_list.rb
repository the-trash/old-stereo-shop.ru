module ActiveAdmin
  module Views
    module IndexAsSortableList
      def sortable_handle_column
        column '', class: 'activeadmin_sortable_list' do |resource|
          sort_url, query_params = resource_path(resource).split '?', 2
          sort_url += "/sort"
          sort_url += "?" + query_params if query_params
          content_tag :span, '&#x2195;'.html_safe, class: 'handle', 'data-sort-url' => sort_url
        end
      end
    end
  end
end

ActiveAdmin::Views::IndexAsTable::IndexTableFor.send(:include, ActiveAdmin::Views::IndexAsSortableList)

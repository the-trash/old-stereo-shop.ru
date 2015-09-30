module ActiveAdmin
  module Views
    module IndexAsSortableList
      def sortable_handle_column(opts = {})
        column '', class: 'activeadmin_sortable_list' do |resource|
          opts_list = {
            class: 'handle',
            data: {
              sort_url: url_for([:sort_list, :admin, resource]),
              position: resource.position
            }
          }

          opts_list.merge!(opts)

          content_tag(:span, "&#8645;".html_safe, opts_list)
        end
      end
    end
  end

  module Sortable
    module ControllerActions
      def sortable_list
        member_action(:sort_list, method: :post) do
          resource.insert_at(params[:position].to_i)
          head 200
        end
      end
    end
  end
end

ActiveAdmin::Views::IndexAsTable::IndexTableFor.send(:include, ActiveAdmin::Views::IndexAsSortableList)
ActiveAdmin::ResourceDSL.send(:include, ActiveAdmin::Sortable::ControllerActions)

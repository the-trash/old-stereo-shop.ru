module ActiveAdmin
  module Inputs
    class MessageInput < ::Formtastic::Inputs::StringInput
      def to_html
        "<div class='active_admin_message_input'>#{label_text}</div>"
      end
    end
  end
  
  module Views
    module FormInputs
      using Refinements::Array::Formatter

      def admin_users_input(resource)
        input :admin_user, as: :select,
          collection: AdminUser.for_select,
          selected: resource.admin_user_id
      end

      def post_categories_input(resource)
        input :post_category,
          as: :select,
          collection: PostCategory.for_select,
          selected: resource.post_category_id
      end

      def states_input(collection, selected)
        input :state,
          as: :select,
          collection: collection.map_with_state_locale,
          selected: selected
      end
    end
  end
end

ActiveAdmin::FormBuilder.send(:include, ActiveAdmin::Views::FormInputs)

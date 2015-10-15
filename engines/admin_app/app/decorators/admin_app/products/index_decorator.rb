module AdminApp
  module Products
    class IndexDecorator < Draper::Decorator
      decorates :product
      delegate_all

      def thumbnail_url
        ActionController::Base.helpers.image_path ImageDecorator.decorate(model).photo_url :product, :related
      end

      def sanitized_desc
        h.truncate Sanitize.fragment(short_desc), length: 400
      end

      def translated_state
        I18n.t state, scope: [:admin, :states]
      end
    end
  end
end

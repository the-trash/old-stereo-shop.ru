module Friendable
  extend ActiveSupport::Concern

  included do
    extend FriendlyId

    friendly_id [:id, :title], use: [:slugged, :finders]
  end
end

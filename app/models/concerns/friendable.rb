module Friendable
  extend ActiveSupport::Concern

  included do
    extend FriendlyId

    friendly_id :slug_candidates, use: [:slugged, :finders]

    def slug_candidates
      [
        :title,
        [:id, :title]
      ]
    end
  end
end

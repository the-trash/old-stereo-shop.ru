module Photoable
  extend ActiveSupport::Concern

  included do
    has_many :photos, -> { order('position DESC') }, as: :photoable, dependent: :destroy do
      def default
        where(default: true).first || first
      end
    end

    accepts_nested_attributes_for :photos, allow_destroy: true, reject_if: :all_blank

    def self.generate_photo
      PhotoSeedsWorker.perform_async self
    end
  end
end

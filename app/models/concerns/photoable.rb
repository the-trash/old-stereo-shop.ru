module Photoable
  extend ActiveSupport::Concern

  included do
    has_many :photos, -> { order('position DESC') }, as: :photoable, dependent: :destroy

    accepts_nested_attributes_for :photos, allow_destroy: true, reject_if: :all_blank
  end
end

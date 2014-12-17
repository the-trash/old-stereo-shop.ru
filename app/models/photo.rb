class Photo < ActiveRecord::Base
  include Statable

  acts_as_list scope: [:photoable_id, :photoable_type]

  belongs_to :photoable, polymorphic: true

  validates :file, presence: true

  mount_uploader :file, PhotoUploader
end

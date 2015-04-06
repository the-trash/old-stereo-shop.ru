# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  photoable_id   :integer
#  photoable_type :string(255)
#  file           :string(255)
#  state          :integer          default(1)
#  position       :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  default        :boolean          default(FALSE)
#
# Indexes
#
#  index_photos_on_photoable_id_and_photoable_type               (photoable_id,photoable_type)
#  index_photos_on_photoable_id_and_photoable_type_and_position  (photoable_id,photoable_type,position)
#  index_photos_on_photoable_id_and_photoable_type_and_state     (photoable_id,photoable_type,state)
#

class Photo < ActiveRecord::Base
  include Statable

  after_commit :recreate_versions!, on: [:create, :update]
  before_save :set_correct_default, if: :need_set_default?

  acts_as_list scope: [:photoable_id, :photoable_type]

  belongs_to :photoable, polymorphic: true

  validates :file, presence: true

  mount_uploader :file, PhotoUploader

  # TODO: when verisions're generating, photo's new record and photoable's nil
  delegate :recreate_versions!, to: :file

  private

  def set_correct_default
    photoable.photos.default.update_column(:default, false)
  end

  def need_set_default?
    default? && photoable.photos.default
  end
end

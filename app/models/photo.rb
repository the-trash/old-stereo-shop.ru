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
#
# Indexes
#
#  index_photos_on_photoable_id_and_photoable_type               (photoable_id,photoable_type)
#  index_photos_on_photoable_id_and_photoable_type_and_position  (photoable_id,photoable_type,position)
#  index_photos_on_photoable_id_and_photoable_type_and_state     (photoable_id,photoable_type,state)
#

class Photo < ActiveRecord::Base
  include Statable

  acts_as_list scope: [:photoable_id, :photoable_type]

  belongs_to :photoable, polymorphic: true

  validates :file, presence: true

  mount_uploader :file, PhotoUploader
end

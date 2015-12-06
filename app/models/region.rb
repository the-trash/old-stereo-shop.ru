# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  title      :string
#  slug       :string
#  vk_id      :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_regions_on_slug   (slug)
#  index_regions_on_title  (title)
#

class Region < ActiveRecord::Base
  include Friendable

  has_many :cities, dependent: :destroy
end

# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  vk_id      :integer
#  region_id  :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_cities_on_region_id  (region_id)
#  index_cities_on_slug       (slug)
#  index_cities_on_title      (title)
#

class City < ActiveRecord::Base
  include Friendable

  scope :by_q, -> (q) { where("title ILIKE :text", text: "%#{ q }%") }

  has_many :users

  belongs_to :region

  validates :region, presence: true

  delegate :title, to: :region, prefix: true
end

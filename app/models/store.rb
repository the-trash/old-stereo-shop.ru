# == Schema Information
#
# Table name: stores
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  slug          :string(255)
#  description   :text
#  latitude      :string(255)
#  longitude     :string(255)
#  happens       :boolean          default(TRUE)
#  state         :integer          default(1)
#  position      :integer          default(0)
#  admin_user_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_stores_on_admin_user_id  (admin_user_id)
#  index_stores_on_position       (position)
#  index_stores_on_slug           (slug)
#  index_stores_on_state          (state)
#

class Store < ActiveRecord::Base
  include Statable, Friendable

  acts_as_list

  scope :products_are, -> { where(happens: true) }
  scope :order_by, -> (field = 'id', how_to_sort = 'asc') {
    order("#{ field } #{ how_to_sort }")
  }

  belongs_to :admin_user

  has_many :products_stores, dependent: :destroy
  has_many :products, through: :products_stores

  validates :title, :admin_user, presence: true
end

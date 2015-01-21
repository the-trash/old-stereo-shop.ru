# == Schema Information
#
# Table name: characteristic_categories
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  admin_user_id :integer
#  position      :integer          default(0)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_characteristic_categories_on_admin_user_id  (admin_user_id)
#  index_characteristic_categories_on_position       (position)
#

class CharacteristicCategory < ActiveRecord::Base
  acts_as_list

  has_many :characteristics, dependent: :destroy

  belongs_to :admin_user

  validates :title, presence: true

  def self.for_select
    all.map{ |pc| [pc.title, pc.id] } if connection.table_exists?(table_name)
  end
end

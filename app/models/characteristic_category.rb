class CharacteristicCategory < ActiveRecord::Base
  acts_as_list

  has_many :characteristics, dependent: :destroy

  belongs_to :admin_user

  validates :title, presence: true

  def self.for_select
    all.map{ |pc| [pc.title, pc.id] }
  end
end

class Brand < ActiveRecord::Base
  include Friendable, Seoble, Statable

  acts_as_list

  belongs_to :admin_user

  has_many :products, dependent: :destroy

  validates :title, :admin_user_id, presence: true
end

class Brand < ActiveRecord::Base
  include Friendable, Seoble

  acts_as_list

  enum state: [:draft, :published, :removed]

  belongs_to :admin_user

  has_many :products, dependent: :destroy

  validates :title, :admin_user_id, presence: true
end

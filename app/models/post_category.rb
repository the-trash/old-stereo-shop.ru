class PostCategory < ActiveRecord::Base
  include Friendable, Seoble

  belongs_to :admin_user

  has_many :posts, dependent: :destroy

  validates :title, :admin_user_id, presence: true
end

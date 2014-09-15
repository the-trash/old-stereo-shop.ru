class PostCategory < ActiveRecord::Base
  include Friendable

  belongs_to :admin_user

  has_many :posts, dependent: :destroy
end

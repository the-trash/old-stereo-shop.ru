class Page < ActiveRecord::Base
  include Friendable, Seoble, Statable

  belongs_to :admin_user

  validates :title, :admin_user_id, presence: true
end

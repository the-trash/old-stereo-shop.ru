class Page < ActiveRecord::Base
  include Friendable, Seoble, Statable

  FEEDBACK_SUBJECTS = %w(product order payment delivery return other)

  belongs_to :admin_user

  validates :title, :admin_user_id, presence: true
end

# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  title         :string
#  slug          :string
#  short_text    :text
#  full_text     :text
#  state         :integer          default(1)
#  meta          :hstore
#  admin_user_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_pages_on_admin_user_id  (admin_user_id)
#  index_pages_on_slug           (slug)
#  index_pages_on_state          (state)
#

class Page < ActiveRecord::Base
  include Friendable, Seoble, Statable

  FEEDBACK_SUBJECTS = %w(product order payment delivery return other)

  belongs_to :admin_user

  validates :title, :admin_user, :full_text, presence: true
end

# == Schema Information
#
# Table name: subscribed_emails
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_subscribed_emails_on_email    (email) UNIQUE
#  index_subscribed_emails_on_user_id  (user_id)
#

class SubscribedEmail < ActiveRecord::Base
  belongs_to :user

  validates :email, presence: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end

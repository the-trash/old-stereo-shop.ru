# == Schema Information
#
# Table name: wishes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  product_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Wish < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
end

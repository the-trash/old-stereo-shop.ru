# == Schema Information
#
# Table name: ratings
#
#  id           :integer          not null, primary key
#  votable_id   :integer
#  votable_type :string
#  user_id      :integer
#  score        :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_ratings_on_votable_id_and_votable_type  (votable_id,votable_type)
#

class Rating < ActiveRecord::Base
  scope :for_removing, ->(score) { where('score > ?', score) }

  belongs_to :votable, polymorphic: true
  belongs_to :user,
    inverse_of: :votes,
    class_name: 'User'

  has_one :review

  validates :votable, :score, presence: true
end

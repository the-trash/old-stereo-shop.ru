class Rating < ActiveRecord::Base
  scope :for_removing, ->(score) { where('score > ?', score) }

  belongs_to :votable, polymorphic: true
  belongs_to :user,
    inverse_of: :votes,
    class_name: 'User'

  has_one :review

  validates :votable, :user_id, :score, presence: true
end

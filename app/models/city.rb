class City < ActiveRecord::Base
  include Friendable

  has_many :users

  belongs_to :region

  validates :region, presence: true
end

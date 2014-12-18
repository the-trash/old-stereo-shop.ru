class City < ActiveRecord::Base
  include Friendable

  belongs_to :region

  validates :region, presence: true
end

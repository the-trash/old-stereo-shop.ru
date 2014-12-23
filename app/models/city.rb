class City < ActiveRecord::Base
  include Friendable

  scope :by_q, -> (q) { where("title ILIKE :text", text: "%#{ q }%") }

  has_many :users

  belongs_to :region

  validates :region, presence: true
end

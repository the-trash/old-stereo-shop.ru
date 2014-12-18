class Region < ActiveRecord::Base
  include Friendable

  has_many :cities
end

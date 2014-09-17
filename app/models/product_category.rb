class ProductCategory < ActiveRecord::Base
  include Friendable, Seoble

  has_ancestry cache_depth: true, depth_cache_column: :depth

  enum state: [:draft, :published, :removed]

  belongs_to :admin_user

  has_many :products, dependent: :destroy

  validates :title, :admin_user_id, presence: true
end

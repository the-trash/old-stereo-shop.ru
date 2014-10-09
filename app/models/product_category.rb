class ProductCategory < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  has_ancestry cache_depth: true, depth_cache_column: :depth

  belongs_to :admin_user

  has_many :products, dependent: :destroy
  has_many :published_products,
    -> { where(state: 1) },
    class_name: 'Product',
    dependent: :destroy
  has_many :removed_products,
    -> { where(state: 2) },
    class_name: 'Product',
    dependent: :destroy

  validates :title, :admin_user_id, presence: true

  def self.for_select
    all.map { |u| [u.title, u.id] }
  end
end

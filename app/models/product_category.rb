class ProductCategory < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  has_ancestry cache_depth: true, depth_cache_column: :depth

  scope :for_front, -> {
    joins(:products).published.
    where(products: { state: 1 }).
    group('product_categories.id')
  }

  belongs_to :admin_user

  has_many :products, dependent: :destroy
  %w(published removed moderated).each_with_index do |st, i|
    has_many :"#{ st }_products",
      -> { where(state: i + 1) },
      class_name: 'Product',
      dependent: :destroy
  end

  validates :title, :admin_user_id, presence: true

  def self.for_select
    all.map { |u| [u.title, u.id] }
  end
end

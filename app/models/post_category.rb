class PostCategory < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  has_ancestry cache_depth: true, depth_cache_column: :depth

  belongs_to :admin_user

  has_many :posts, dependent: :destroy

  validates :title, :admin_user_id, presence: true

  def self.for_select
    all.map{ |pc| [pc.title, pc.id] } if connection.table_exists?(table_name)
  end
end

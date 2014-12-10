class PostCategory < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  has_ancestry cache_depth: true, depth_cache_column: :depth

  belongs_to :admin_user

  %i(posts newletters).each do |r|
    has_many r, dependent: :destroy
  end

  validates :title, :admin_user_id, presence: true

  def self.for_select
    all.map{ |pc| [pc.title, pc.id] } if connection.table_exists?(table_name)
  end
end

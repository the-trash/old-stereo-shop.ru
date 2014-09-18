class PostCategory < ActiveRecord::Base
  include Friendable, Seoble

  has_ancestry cache_depth: true, depth_cache_column: :depth

  enum state: [:draft, :published, :removed]

  belongs_to :admin_user

  has_many :posts, dependent: :destroy

  validates :title, :admin_user_id, presence: true

  def self.for_select
    PostCategory.all.map{ |pc| [pc.title, pc.id] }
  end
end

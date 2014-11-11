class PostCategory < ActiveRecord::Base
  include Friendable, Seoble, Statable, Photoable

  PAGE_POSITION = %i(top_menu who_are_we convenience_and_safety)

  enum page_position: PAGE_POSITION

  has_ancestry cache_depth: true, depth_cache_column: :depth

  belongs_to :admin_user

  has_many :posts, dependent: :destroy

  validates :title, :admin_user_id, presence: true

  def self.for_select
    all.map{ |pc| [pc.title, pc.id] } if connection.table_exists?(table_name)
  end

  def self.page_position_for_select
    page_positions.map { |position_name, position_number| [position_name, position_number] }
  end
end

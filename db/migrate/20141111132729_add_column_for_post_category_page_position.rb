class AddColumnForPostCategoryPagePosition < ActiveRecord::Migration
  def change
    add_column :post_categories, :page_position, :integer
  end
end

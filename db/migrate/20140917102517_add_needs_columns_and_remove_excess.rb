class AddNeedsColumnsAndRemoveExcess < ActiveRecord::Migration
  def change
    %i(posts post_categories products product_categories).each do |t|
      %i(lft rgt parent_id depth).each do |f|
        remove_column t, f, :integer
      end
    end

    %i(posts products brands post_categories product_categories).each do |t|
      add_column t, :position, :integer, default: 0
      add_index t, :position
    end

    %i(post_categories product_categories).each do |t|
      add_column t, :ancestry, :string
      add_column t, :depth, :integer
      add_index t, :ancestry
    end
  end
end

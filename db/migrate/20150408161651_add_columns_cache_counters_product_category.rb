class AddColumnsCacheCountersProductCategory < ActiveRecord::Migration
  def change
    %w(moderated draft).each do |state|
      add_column :product_categories, "#{state}_products_count", :integer, default: 0
    end
  end
end

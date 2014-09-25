class AddColumnsForProductsRatings < ActiveRecord::Migration
  def change
    add_column :products, :score_weight, :integer, default: 5
    add_column :products, :average_score, :integer, default: 0
  end
end

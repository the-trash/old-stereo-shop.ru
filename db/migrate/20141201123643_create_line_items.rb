class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :cart, index: true
      t.belongs_to :product, index: true
      t.belongs_to :order, index: true
      t.integer :quantity, default: 1
    end

    add_index :line_items, [:cart_id, :product_id], unique: true
  end
end

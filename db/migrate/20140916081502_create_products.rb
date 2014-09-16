class CreateProducts < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :products do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.integer :state, default: 1
      t.decimal :price, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :discount, precision: 10, scale: 2, default: 0.0, null: false

      t.belongs_to :admin_user
      t.belongs_to :brand
      t.belongs_to :product_category

      t.integer :lft
      t.integer :rgt
      t.integer :parent_id
      t.integer :depth

      t.hstore :meta

      t.timestamps
    end

    add_index :products, :admin_user_id
    add_index :products, :brand_id
    add_index :products, :product_category_id
    add_index :products, :state
  end
end

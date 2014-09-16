class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.integer :state, default: 1
      t.belongs_to :admin_user

      t.integer :lft
      t.integer :rgt
      t.integer :parent_id
      t.integer :depth

      t.hstore :meta

      t.timestamps
    end

    add_index :product_categories, :admin_user_id
    add_index :product_categories, :state
    add_index :product_categories, :slug
  end
end

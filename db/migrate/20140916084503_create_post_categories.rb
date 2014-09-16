class CreatePostCategories < ActiveRecord::Migration
  def change
    create_table :post_categories do |t|
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

    add_index :post_categories, :admin_user_id
    add_index :post_categories, :state
    add_index :post_categories, :slug
  end
end

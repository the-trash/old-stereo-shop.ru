class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description
      t.text :full_text
      t.integer :state, default: 1

      t.belongs_to :admin_user
      t.belongs_to :post_category

      t.integer :lft
      t.integer :rgt
      t.integer :parent_id
      t.integer :depth

      t.hstore :meta

      t.timestamps
    end

    add_index :posts, :admin_user_id
    add_index :posts, :post_category_id
    add_index :posts, :state
  end
end

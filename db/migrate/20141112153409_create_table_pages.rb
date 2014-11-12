class CreateTablePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :slug

      t.text :short_text
      t.text :full_text

      t.integer :state, default: 1
      t.integer :position, default: 0

      t.hstore :meta

      t.belongs_to :admin_user
      t.belongs_to :post_category

      t.timestamps
    end

    add_index :pages, :admin_user_id
    add_index :pages, :post_category_id
    add_index :pages, :state
    add_index :pages, :slug
    add_index :pages, :position
    add_index :pages, [:post_category_id, :position]
  end
end

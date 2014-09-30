class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :title
      t.string :slug
      t.text :description

      t.string :latitude
      t.string :longitude

      t.boolean :happens, default: true
      t.integer :state, default: 1
      t.integer :position, default: 0

      t.belongs_to :admin_user

      t.timestamps
    end

    add_index :stores, :admin_user_id
    add_index :stores, :position
    add_index :stores, :state
    add_index :stores, :slug

    create_table :products_stores do |t|
      t.belongs_to :product
      t.belongs_to :store
      t.integer :count, null: false
    end

    add_index :products_stores, :product_id
    add_index :products_stores, :store_id
    add_index :products_stores, [:product_id, :store_id], name: 'composite_product_store', unique: true
  end
end

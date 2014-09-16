class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.string :site_link
      t.integer :state, default: 1
      t.belongs_to :admin_user

      t.hstore :meta

      t.timestamps
    end

    add_index :brands, :admin_user_id
    add_index :brands, :state
    add_index :brands, :slug
  end
end

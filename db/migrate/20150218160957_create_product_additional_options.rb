class CreateProductAdditionalOptions < ActiveRecord::Migration
  def change
    create_table :product_additional_options do |t|
      t.string :title
      t.string :slug

      t.integer :render_type, default: 0
      t.integer :state, default: 1

      t.belongs_to :product, index: true

      t.timestamps
    end

    add_index :product_additional_options, :state
    add_index :product_additional_options, [:product_id, :state]
  end
end

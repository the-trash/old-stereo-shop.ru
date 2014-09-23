class CreateCharacteristicsProducts < ActiveRecord::Migration
  def change
    create_table :characteristics_products do |t|
      t.belongs_to :product
      t.belongs_to :characteristic
      t.string :value
    end

    add_index :characteristics_products, :product_id
    add_index :characteristics_products, :characteristic_id
    add_index :characteristics_products, [:product_id, :characteristic_id], name: 'composite_product_characteristic', unique: true
  end
end

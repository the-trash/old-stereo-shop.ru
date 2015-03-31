class CreateProductAttributesValue < ActiveRecord::Migration
  def change
    create_table :product_attributes_values do |t|
      t.belongs_to :additional_options_value

      t.integer :state, default: 1
      t.integer :product_attribute

      t.string :new_value
    end

    add_index :product_attributes_values, :additional_options_value_id, name: :additional_options_value_with_new_value
    add_index :product_attributes_values, :state
    add_index :product_attributes_values, :product_attribute

    add_column :product_additional_options_values, :state, :integer, default: 1
    add_index :product_additional_options_values, :state
  end
end

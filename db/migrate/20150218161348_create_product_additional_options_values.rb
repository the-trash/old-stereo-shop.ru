class CreateProductAdditionalOptionsValues < ActiveRecord::Migration
  def change
    create_table :product_additional_options_values do |t|
      t.belongs_to :product_additional_option

      t.string :value
    end

    add_index :product_additional_options_values, :product_additional_option_id, name: :additional_options_id_index
  end
end

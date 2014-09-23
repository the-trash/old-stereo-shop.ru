class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.string :title
      t.integer :position, default: 0
      t.belongs_to :characteristic_category
      t.string :unit

      t.timestamps
    end

    add_index :characteristics, [:characteristic_category_id, :position], name: 'characteristic_category_position'
    add_index :characteristics, :characteristic_category_id
  end
end

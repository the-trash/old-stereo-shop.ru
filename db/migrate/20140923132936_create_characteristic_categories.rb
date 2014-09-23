class CreateCharacteristicCategories < ActiveRecord::Migration
  def change
    create_table :characteristic_categories do |t|
      t.string :title
      t.belongs_to :admin_user
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :characteristic_categories, :position
    add_index :characteristic_categories, :admin_user_id
  end
end

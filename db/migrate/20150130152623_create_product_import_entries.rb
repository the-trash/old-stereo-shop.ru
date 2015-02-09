class CreateProductImportEntries < ActiveRecord::Migration
  def change
    create_table :product_import_entries do |t|
      t.belongs_to :import, index: true

      t.string :state

      t.text :import_errors

      t.hstore :data

      t.timestamps
    end

    add_index :product_import_entries, :state
    add_index :product_import_entries, [:import_id, :state]
  end
end

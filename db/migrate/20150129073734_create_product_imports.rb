class CreateProductImports < ActiveRecord::Migration
  def change
    create_table :product_imports do |t|
      t.belongs_to :admin_user, index: true

      t.string :file
      t.string :state

      t.integer :import_entries_count
      t.integer :completed_import_entries_count
      t.integer :failed_import_entries_count

      t.timestamps
    end

    add_index :product_imports, :state
  end
end

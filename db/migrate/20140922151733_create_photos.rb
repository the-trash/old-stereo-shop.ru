class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :photoable, polymorphic: true
      t.string :file
      t.integer :state, default: 1
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :photos, [:photoable_id, :photoable_type]
    add_index :photos, [:photoable_id, :photoable_type, :state]
    add_index :photos, [:photoable_id, :photoable_type, :position]
  end
end

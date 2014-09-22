# This migration comes from activeadmin_wysihtml5 (originally 20120816182611)
class CreateActiveAdminWysihtml5Assets < ActiveRecord::Migration

  def change
    create_table :assets do |t|
      t.string :storage_uid
      t.string :storage_name
      t.integer :storage_width
      t.integer :storage_height
      t.decimal :storage_aspect_ratio
      t.integer :storage_depth
      t.string :storage_format
      t.string :storage_mime_type
      t.string :storage_size

      t.timestamps
    end
  end

end

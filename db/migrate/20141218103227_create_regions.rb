class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :title
      t.string :slug

      t.integer :vk_id

      t.timestamps
    end

    %i(title slug).each { |field| add_index :regions, field }
  end
end

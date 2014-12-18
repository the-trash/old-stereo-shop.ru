class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :title
      t.string :slug

      t.integer :vk_id

      t.belongs_to :region, index: true

      t.timestamps
    end

    %i(title slug).each { |field| add_index :cities, field }
  end
end

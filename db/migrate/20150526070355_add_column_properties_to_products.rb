class AddColumnPropertiesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :properties, :hstore
  end
end

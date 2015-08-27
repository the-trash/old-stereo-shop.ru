class AddSeoFieldsToStores < ActiveRecord::Migration
  def change
    add_column :stores, :meta, :hstore, null: false, default: {}
  end
end

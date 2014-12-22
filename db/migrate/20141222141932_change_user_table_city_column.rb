class ChangeUserTableCityColumn < ActiveRecord::Migration
  def change
    rename_column :users, :city, :city_id
    add_index :users, :city_id
  end
end

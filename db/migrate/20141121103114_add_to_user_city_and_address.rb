class AddToUserCityAndAddress < ActiveRecord::Migration
  def change
    add_column :users, :city, :integer, default: 0
    add_column :users, :address, :string
    add_column :users, :index, :integer
  end
end
